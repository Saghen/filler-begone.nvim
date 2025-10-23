--- Prevents neovim from scrolling past the bottom of the buffer and showing unnecessary `:h filler-lines`
--- @param win number
local function filler_begone(win)
  assert(type(win) == 'number', 'window is not a number: ' .. win)
  assert(vim.api.nvim_win_is_valid(win), 'invalid window: ' .. win)

  local buf = vim.api.nvim_win_get_buf(win)
  if vim.b[buf].filler_begone == false then return end

  local line_count = vim.api.nvim_buf_line_count(buf)

  local win_height = math.min(vim.api.nvim_win_get_height(win), line_count)

  -- check how many lines are visible from the buffer, starting from the line currently at the top of the window
  local top_line = vim.fn.line('w0', win) - 1 -- 1-indexed -> 0-indexed
  local visible_buffer_lines = vim.api.nvim_win_text_height(win, {
    start_row = top_line,
    end_row = math.max(math.min(top_line + win_height - 1, line_count - 1), 0),
  }).all
  local out_of_buf_lines = win_height - visible_buffer_lines

  if out_of_buf_lines > 0 then
    vim.api.nvim_win_call(win, function()
      -- start from the last line, calculate the height of each line, including virtual text and wrapping
      -- until we reach the height of the window
      local accumulated_line_height = 0
      local target_line = line_count - 1
      while target_line > 0 do
        -- ignore if line is folded
        local fold_closed_line = vim.fn.foldclosed(target_line)
        if fold_closed_line ~= -1 and fold_closed_line ~= target_line then
          target_line = target_line - 1

        -- otherwise, count the visible height of the line
        else
          local line_height = vim.api.nvim_win_text_height(win, {
            start_row = target_line,
            end_row = target_line,
          }).all
          accumulated_line_height = accumulated_line_height + line_height

          -- current line would go beyond win height, go back down one line
          if accumulated_line_height > win_height then target_line = target_line + 1 end
          if accumulated_line_height >= win_height then break end

          target_line = target_line - 1
        end
      end

      -- scroll to the target line
      vim.fn.winrestview({ topline = target_line + 1 }) -- 0-indexed -> 1-indexed

      -- force another event loop iteration, with updated topline
      -- https://github.com/neovim/neovim/issues/35633#issuecomment-3256274806
      vim.schedule(function()
        vim.fn.winrestview({ topline = target_line + 1 }) -- 0-indexed -> 1-indexed
      end)
      vim.api.nvim_feedkeys(vim.keycode('<Ignore>'), 'ni', false)
    end)
  end
end

return filler_begone
