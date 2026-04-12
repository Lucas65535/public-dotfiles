local theme = require("config.theme")

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "main",
    },
    lazy = false,
    priority = 1000,
  },
  {
    "ThorstenRhau/token",
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = theme.get_colorscheme("token"),
    },
  },
}
