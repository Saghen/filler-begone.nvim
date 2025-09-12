# neverflow.nvim

Prevents neovim from scrolling past the bottom of the buffer and showing unnecessary `:h filler-lines`. Disable globally with `vim.g.neverflow = false` or per-buffer with `vim.b.neverflow = false`. Plugin initializes itself automatically, just add it to your package manager.

The name comes from "never overflow" -> "neverflow".

> "i hate the filler lines with a passion" - justinmk

Special thanks to [zeertzjq](https://github.com/zeertzjq), [justinmk](https://github.com/justinmk), [seandewar](https://github.com/seandewar), and [echasnovski](https://github.com/echasnovski) for their help!

## Installation

```lua
-- lazy.nvim
{ 'saghen/neverflow.nvim' }

-- vim.pack
vim.pack.add({ 'https://github.com/saghen/neverflow.nvim' })

-- mini.deps
MiniDeps.add({ source = 'saghen/neverflow.nvim' })
```
