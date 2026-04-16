-- Claude Code colorscheme for Neovim
-- Main entry point: require("claude-code").setup({ variant = "dark" | "light" })

local M = {}

M.config = {
  variant = "dark", -- "dark" or "light"
}

--- Load the colorscheme.
---@param opts? { variant?: "dark"|"light" }
function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", M.config, opts)
end

--- Apply the colorscheme (called by colors/*.lua).
---@param variant? "dark"|"light"
function M.load(variant)
  variant = variant or M.config.variant

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = (variant == "light") and "light" or "dark"
  vim.g.colors_name = "claude-code-" .. variant

  local palette = require("claude-code.palette")
  local p = (variant == "light") and palette.light or palette.dark

  local highlights = require("claude-code.highlights")
  highlights.apply(p)

  -- Lualine theme (expose for lualine integration)
  M.lualine = M._build_lualine(p, variant)
end

--- Build lualine theme table from palette.
function M._build_lualine(p, variant)
  return {
    normal = {
      a = { fg = p.bg, bg = p.accent, gui = "bold" },
      b = { fg = p.fg_muted, bg = p.bg_inset },
      c = { fg = p.fg_muted, bg = p.bg_alt },
    },
    insert = {
      a = { fg = p.bg, bg = p.green, gui = "bold" },
      b = { fg = p.fg_muted, bg = p.bg_inset },
    },
    visual = {
      a = { fg = p.bg, bg = p.magenta, gui = "bold" },
      b = { fg = p.fg_muted, bg = p.bg_inset },
    },
    replace = {
      a = { fg = p.bg, bg = p.red, gui = "bold" },
      b = { fg = p.fg_muted, bg = p.bg_inset },
    },
    command = {
      a = { fg = p.bg, bg = p.yellow, gui = "bold" },
      b = { fg = p.fg_muted, bg = p.bg_inset },
    },
    terminal = {
      a = { fg = p.bg, bg = p.cyan, gui = "bold" },
      b = { fg = p.fg_muted, bg = p.bg_inset },
    },
    inactive = {
      a = { fg = p.fg_subtle, bg = p.bg_alt },
      b = { fg = p.fg_subtle, bg = p.bg_alt },
      c = { fg = p.fg_subtle, bg = p.bg_alt },
    },
  }
end

return M
