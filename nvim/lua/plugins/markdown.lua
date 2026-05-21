local function patch_markdown_preview_routes(plugin_dir)
  plugin_dir = plugin_dir or (vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim")

  local routes = plugin_dir .. "/app/routes.js"
  if vim.fn.filereadable(routes) ~= 1 then
    return
  end

  local lines = vim.fn.readfile(routes)
  local patched = false

  local redirect_route = {
    "// /:number",
    "use((req, res, next) => {",
    "  if (/^\\/\\d+$/.test(req.asPath)) {",
    "    res.statusCode = 302",
    "    res.setHeader('Location', `/page${req.asPath}`)",
    "    return res.end()",
    "  }",
    "  next()",
    "})",
    "",
  }

  local has_redirect_route = false
  for i, line in ipairs(lines) do
    if line == "// /:number" then
      has_redirect_route = true
    end

    local start_pos, end_pos = line:find([[/(?:\/page)?\/\d+/]], 1, true)
    if start_pos then
      lines[i] = line:sub(1, start_pos - 1) .. [[/\/page\/\d+/]] .. line:sub(end_pos + 1)
      patched = true
    end
  end

  if not has_redirect_route then
    local insert_at = nil
    for i, line in ipairs(lines) do
      if line == "// /page/:number" then
        insert_at = i
        break
      end
    end

    if insert_at then
      for i = #redirect_route, 1, -1 do
        table.insert(lines, insert_at, redirect_route[i])
      end
      patched = true
    end
  end

  if patched then
    pcall(vim.fn.writefile, lines, routes)
  end
end

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

  -- Browser-based Markdown preview styled with Claude Code palette
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function(plugin)
      vim.fn["mkdp#util#install"]()
      patch_markdown_preview_routes(plugin and plugin.dir)
    end,
    keys = {
      { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_markdown_css = vim.fn.stdpath("config") .. "/static/markdown-preview.css"
      patch_markdown_preview_routes()
    end,
  },
}
