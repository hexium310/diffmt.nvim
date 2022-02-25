local config = require('diffmt/config')

local M = {}

---@param data string[]
---@return number @Buffer handle
local function open_diff_win(data)
  local filename = vim.api.nvim_buf_get_name(0)
  local filetype = vim.bo.filetype
  local buf = vim.api.nvim_create_buf(false, true)

  vim.cmd([[
    diffthis
    leftabove vsplit
  ]])
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, data)
  vim.bo.filetype = filetype
  vim.bo.modifiable = false
  vim.bo.readonly = true
  vim.bo.bufhidden = 'wipe'
  vim.cmd(([[
    diffthis
    file diffmt://%s
  ]]):format(filename))

  return buf
end

---@param filetype string
---@return string | nil
local function ft_to_formatter_name(filetype)
  for command, formatter in pairs(config.get().formatters) do
    if vim.tbl_contains(formatter.filetypes, filetype) then
      return command
    end
  end

  return nil
end

function M.diff(callback)
  local filetype = vim.bo.filetype
  local formatter_name = ft_to_formatter_name(filetype)
  local disabled = vim.tbl_contains(config.get().disables, formatter_name)
  local executable = vim.fn.executable(formatter_name)

  if formatter_name == nil or disabled or not executable then
    return
  end

  local formatter = config.get().formatters[formatter_name]

  local stdin = vim.loop.new_pipe(false)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local handle, pid
  handle, pid = vim.loop.spawn(
    formatter.command,
    {
      args = formatter.args,
      stdio = {
        stdin,
        stdout,
        stderr,
      }
    },
    function ()
      stdout:close()
      stderr:close()
      handle:close()
      callback()
    end
  )

  if handle == nil and pid == 'ENOENT: no such file or directory' then
    vim.notify(('Command is not found: %s'):format(formatter.command), vim.log.levels.ERROR)
    stdin:close()
    stdout:close()
    stderr:close()
    return
  end

  stdout:read_start(vim.schedule_wrap(function(err, data)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
    end

    if data == nil then
      return
    end

    open_diff_win(vim.fn.split(data, '\n', false))
  end))

  stderr:read_start(vim.schedule_wrap(function (err, data)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
    end

    if data == nil then
      return
    end

    vim.notify(data, vim.log.levels.INFO)
  end))

  stdin:write(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, true), '\n'), function ()
    stdin:close()
    vim.loop.stop()
  end)
end

return M
