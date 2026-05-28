-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<ESC>", { silent = true })

local theme = require("config.theme")

require("which-key").add({
  { "<leader>h", group = "HTML" },
  { "<leader>uB", group = "Background" },
  { "<leader>uC", group = "Colorscheme" },
})

-- ── HTML preview ───────────────────────────────────────────

local html_preview = {
  job_id = nil,
  root = nil,
  port = 4321,
}

local function notify_html(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "HTML Preview" })
end

local function is_job_running(job_id)
  return job_id ~= nil and vim.fn.jobwait({ job_id }, 0)[1] == -1
end

local function encode_url_segment(segment)
  return (segment:gsub("([^%w%-%._~])", function(char)
    return string.format("%%%02X", string.byte(char))
  end))
end

local function encode_url_path(path)
  local parts = vim.split(path, "/", { plain = true })
  for index, part in ipairs(parts) do
    parts[index] = encode_url_segment(part)
  end
  return table.concat(parts, "/")
end

local function open_url(url)
  local command

  if vim.fn.has("macunix") == 1 then
    command = { "open", url }
  elseif vim.fn.has("unix") == 1 then
    command = { "xdg-open", url }
  elseif vim.fn.has("win32") == 1 then
    command = { "cmd", "/c", "start", "", url }
  else
    notify_html("No browser opener is configured for this platform", vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart(command, { detach = true })
end

local function stop_html_preview()
  if is_job_running(html_preview.job_id) then
    vim.fn.jobstop(html_preview.job_id)
  end

  html_preview.job_id = nil
  html_preview.root = nil
end

local function get_html_preview_target()
  local file = vim.fs.normalize(vim.fn.expand("%:p"))
  if file == "" or vim.fn.filereadable(file) ~= 1 then
    return nil, "Current buffer is not a readable file"
  end

  local extension = vim.fn.fnamemodify(file, ":e"):lower()
  if extension ~= "html" and extension ~= "htm" then
    return nil, "Current buffer is not an HTML file"
  end

  local cwd = vim.fs.normalize(vim.fn.getcwd())
  local root = cwd
  local relative_path

  if file == cwd or vim.startswith(file, cwd .. "/") then
    relative_path = file:sub(#cwd + 2)
  else
    root = vim.fs.dirname(file)
    relative_path = vim.fn.fnamemodify(file, ":t")
  end

  return {
    root = root,
    relative_path = relative_path,
    url = ("http://127.0.0.1:%d/%s"):format(html_preview.port, encode_url_path(relative_path)),
  }
end

vim.keymap.set("n", "<leader>hl", function()
  if vim.fn.executable("vite") ~= 1 then
    notify_html("vite is not installed. Run: npm install -g vite", vim.log.levels.ERROR)
    return
  end

  local target, error_message = get_html_preview_target()
  if not target then
    notify_html(error_message, vim.log.levels.WARN)
    return
  end

  if is_job_running(html_preview.job_id) and html_preview.root == target.root then
    open_url(target.url)
    return
  end

  stop_html_preview()

  local job_id
  job_id = vim.fn.jobstart({
    "vite",
    target.root,
    "--host",
    "127.0.0.1",
    "--port",
    tostring(html_preview.port),
    "--strictPort",
  }, {
    on_exit = function(_, code)
      if html_preview.job_id == job_id then
        html_preview.job_id = nil
        html_preview.root = nil
      end

      if code ~= 0 then
        notify_html(("vite exited with code %d"):format(code), vim.log.levels.ERROR)
      end
    end,
  })

  if job_id <= 0 then
    notify_html("Failed to start vite", vim.log.levels.ERROR)
    return
  end

  html_preview.job_id = job_id
  html_preview.root = target.root

  vim.defer_fn(function()
    open_url(target.url)
  end, 700)

  notify_html(("Serving %s at %s"):format(target.root, target.url))
end, { desc = "HTML Live Preview", silent = true })

vim.keymap.set("n", "<leader>hS", function()
  stop_html_preview()
  notify_html("Stopped vite")
end, { desc = "Stop HTML Preview", silent = true })

vim.keymap.set("n", "<leader>ho", function()
  local file = vim.fn.expand("%:p")
  if file == "" or vim.fn.filereadable(file) ~= 1 then
    notify_html("Current buffer is not a readable file", vim.log.levels.WARN)
    return
  end

  open_url(vim.uri_from_fname(file))
end, { desc = "Open HTML File", silent = true })

-- ── Colorscheme switching ───────────────────────────────────

vim.keymap.set("n", "<leader>uCd", function()
  theme.set_colorscheme("claude-code-dark")
end, { desc = "Claude Code Dark", silent = true })

vim.keymap.set("n", "<leader>uCl", function()
  theme.set_colorscheme("claude-code-light")
end, { desc = "Claude Code Light", silent = true })

-- -- Previous themes (disabled)
-- vim.keymap.set("n", "<leader>uCt", function()
--   theme.set_colorscheme("token")
-- end, { desc = "Use Token theme", silent = true })
--
-- vim.keymap.set("n", "<leader>uCr", function()
--   theme.set_colorscheme("rose-pine")
-- end, { desc = "Use Rose Pine theme", silent = true })

-- ── Background switching ────────────────────────────────────

vim.keymap.set("n", "<leader>uBd", function()
  theme.set_background("dark")
end, { desc = "Use Dark background", silent = true })

vim.keymap.set("n", "<leader>uBl", function()
  theme.set_background("light")
end, { desc = "Use Light background", silent = true })
