local M = {}

local state_file = vim.fn.stdpath("state") .. "/theme.json"

local function read_state()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  if not ok or not lines or #lines == 0 then
    return {}
  end

  local content = table.concat(lines, "\n")
  local decoded_ok, data = pcall(vim.json.decode, content)
  if not decoded_ok or type(data) ~= "table" then
    return {}
  end

  return data
end

local function write_state(state)
  vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
  vim.fn.writefile({ vim.json.encode(state) }, state_file)
end

function M.get_state()
  local state = read_state()

  if state.background ~= "dark" and state.background ~= "light" then
    state.background = nil
  end

  if type(state.colorscheme) ~= "string" or state.colorscheme == "" then
    state.colorscheme = nil
  end

  return state
end

function M.get_background(default)
  return M.get_state().background or default
end

function M.get_colorscheme(default)
  return M.get_state().colorscheme or default
end

function M.save_state(state)
  local current = M.get_state()
  write_state(vim.tbl_extend("force", current, state))
end

function M.set_colorscheme(name)
  local ok, err = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.notify("Failed to set colorscheme: " .. name .. "\n" .. err, vim.log.levels.ERROR)
    return
  end

  M.save_state({
    colorscheme = name,
    background = vim.o.background,
  })
  vim.notify("Colorscheme: " .. name, vim.log.levels.INFO)
end

function M.set_background(mode)
  vim.o.background = mode

  local current = vim.g.colors_name or M.get_colorscheme("token")
  local ok, err = pcall(vim.cmd.colorscheme, current)
  if not ok then
    vim.notify("Failed to refresh colorscheme: " .. current .. "\n" .. err, vim.log.levels.ERROR)
    return
  end

  M.save_state({
    colorscheme = current,
    background = mode,
  })
  vim.notify("Background: " .. mode, vim.log.levels.INFO)
end

return M
