-- LazyVim plugin spec for Claude Code colorscheme
-- Add this to ~/.config/nvim/lua/plugins/colorscheme.lua
--
-- This loads the colorscheme from the local directory and sets it as default.
-- Supports both dark and light variants.

return {
  {
    -- Load from local directory
    dir = "~/code/public-dotfiles/claude-theme/nvim/claude-code.nvim",
    name = "claude-code",
    lazy = false,
    priority = 1000,  -- load before other plugins
    opts = {
      -- "dark" or "light"
      variant = "dark",
    },
    config = function(_, opts)
      require("claude-code").setup(opts)
    end,
  },

  -- Set as the LazyVim colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "claude-code-dark",
      -- For light mode, use: colorscheme = "claude-code-light",
    },
  },

  -- Lualine integration (optional — uses the built-in lualine theme)
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = {
      options = {
        theme = "claude-code",
      },
    },
  },
}
