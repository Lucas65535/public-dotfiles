return {
  "okuuva/auto-save.nvim",
  lazy = false,
  opts = {
    debounce_delay = 500,
  },
  keys = {
    { "<leader>uv", "<cmd>ASToggle<CR>", desc = "Toggle autosave" },
  },
  init = function()
    local group = vim.api.nvim_create_augroup('autosave', {})
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AutoSaveWritePost',
      group = group,
      callback = function(opts)
        if opts.data.saved_buffer ~= nil then
          local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
          local basename = vim.fn.fnamemodify(filename, ":t")
          vim.notify('AutoSave: saved ' .. basename .. ' at ' .. vim.fn.strftime('%H:%M:%S'), vim.log.levels.INFO)
        end
      end,
    })
  end,
}
