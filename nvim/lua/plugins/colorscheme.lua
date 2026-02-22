return {
  -- Configure Rose-pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "main", -- dark theme (default). Other options: "moon" (softer dark)
    },
  },
  -- Tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
