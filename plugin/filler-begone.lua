local autocmd_group = vim.api.nvim_create_augroup('filler-begone', {})

vim.api.nvim_create_autocmd('WinScrolled', {
  group = autocmd_group,
  callback = function()
    if vim.g.filler_begone == false then return end

    local filler_begone = require('filler-begone')

    -- `vim.v.event` contains a table of all windows that have scrolled
    -- and an 'all' key which we can ignore
    for win, _ in pairs(vim.v.event) do
      if win ~= 'all' then
        local winnr = tonumber(win)
        assert(winnr ~= nil, 'window is not a number: ' .. win)
        filler_begone(winnr)
      end
    end
  end,
})
