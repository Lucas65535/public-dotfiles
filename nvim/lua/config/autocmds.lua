-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable diagnostics virtual text and spell checking for Markdown files to reduce noise
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    -- Disable spell check (which often adds a lot of underlines in Markdown)
    vim.opt_local.spell = false
    -- Enable conceallevel to allow plugins to render icons instead of syntax markers
    vim.opt_local.conceallevel = 2
    -- Prevent markers from reappearing when the cursor is on the line in Normal mode
    -- This ensures the Roman numerals stay visible
    vim.opt_local.concealcursor = "nc"
    -- Disable virtual text diagnostics for the current buffer to keep the view clean
    vim.diagnostic.config({
      virtual_text = false,
    }, event.buf)
  end,
})
