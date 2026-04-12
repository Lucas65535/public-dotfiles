-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local theme = require("config.theme")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.background = theme.get_background(vim.o.background)
