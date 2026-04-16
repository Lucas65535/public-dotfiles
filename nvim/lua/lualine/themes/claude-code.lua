-- Lualine theme for Claude Code colorscheme
-- Auto-discovered by lualine when placed in lualine/themes/
-- Falls back to dark palette if colorscheme hasn't been loaded yet.

local claude = require("claude-code")

-- If lualine loads before the colorscheme, build a default theme
if not claude.lualine then
  local palette = require("claude-code.palette")
  claude.lualine = claude._build_lualine(palette.dark, "dark")
end

return claude.lualine
