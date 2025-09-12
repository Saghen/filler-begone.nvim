local autocmd_group = vim.api.nvim_create_augroup('neverflow', {})

vim.api.nvim_create_autocmd('WinScrolled', {
  group = autocmd_group,
  callback = function()
    if vim.g.neverflow == false then return end

    local neverflow = require('neverflow')

    -- `vim.v.event` contains a table of all windows that have scrolled
    -- and an 'all' key which we can ignore
    for win, _ in pairs(vim.v.event) do
      if win ~= 'all' then
        local winnr = tonumber(win)
        assert(winnr ~= nil, 'window is not a number: ' .. win)
        neverflow(winnr)
      end
    end
  end,
})
