-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<ESC>", { silent = true })

local theme = require("config.theme")

require("which-key").add({
  { "<leader>uB", group = "Background" },
  { "<leader>uC", group = "Colorscheme" },
})

vim.keymap.set("n", "<leader>uCt", function()
  theme.set_colorscheme("token")
end, { desc = "Use Token theme", silent = true })

vim.keymap.set("n", "<leader>uCr", function()
  theme.set_colorscheme("rose-pine")
end, { desc = "Use Rose Pine theme", silent = true })

vim.keymap.set("n", "<leader>uBd", function()
  theme.set_background("dark")
end, { desc = "Use Dark background", silent = true })

vim.keymap.set("n", "<leader>uBl", function()
  theme.set_background("light")
end, { desc = "Use Light background", silent = true })
