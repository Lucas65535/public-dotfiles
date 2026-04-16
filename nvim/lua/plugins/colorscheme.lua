-- Colorscheme configuration
-- Claude Code theme is built-in (see lua/claude-code/ and colors/).
-- Old themes are preserved below for reference.

local theme = require("config.theme")

return {
  -- ── Claude Code (built-in) ────────────────────────────────
  -- No plugin dependency needed — the colorscheme lives in
  -- colors/ and lua/claude-code/ within this config directory.
  -- Neovim discovers it natively via :colorscheme command.

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = theme.get_colorscheme("claude-code-light"),
    },
  },

  -- Lualine integration (auto-discovered from lua/lualine/themes/)
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = {
      options = {
        theme = "claude-code",
      },
    },
  },

  -- ── Previous themes (disabled) ────────────────────────────
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   opts = {
  --     variant = "main",
  --   },
  --   lazy = false,
  --   priority = 1000,
  -- },
  -- {
  --   "ThorstenRhau/token",
  --   lazy = false,
  --   priority = 1000,
  -- },
}
