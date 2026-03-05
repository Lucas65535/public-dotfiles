return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        enabled = true,
        -- sign = false ensures we don't have multiple icons in the sign column
        sign = false,
        -- Classic Roman numeral icons for H1 to H6
        icons = { "Ⅰ ", "Ⅱ ", "Ⅲ ", "Ⅳ ", "Ⅴ ", "Ⅵ " },
        -- 'full' mode provides background colors to clearly distinguish header levels
        width = "full",
        left_pad = 0,
        right_pad = 2,
      },
      -- Enhanced rendering for code blocks, checkboxes, etc.
      code = {
        sign = false,
        width = "block",
        right_pad = 2,
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = " " },
      },
      -- Render in all modes to maintain visual consistency
      render_modes = { "n", "c", "i", "v" },
    },
  },

  -- Keep a quiet editing environment by disabling noisy linters for Markdown
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
}
