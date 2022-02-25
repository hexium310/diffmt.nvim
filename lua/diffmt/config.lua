---Formatter configuration
---@class DiffmtFormatterConfig
---@field command string @Name or path for an executable command.
---@field args string[] | nil @Command arguments.
---@field filetypes string[] @Filetypes in which the command is executed.

---Plugin configuration
---@class DiffmtConfig
---@field disables string[] @Commands you dont't want to execute.
---@field formatters table<string, DiffmtFormatterConfig> @Pairs of command and formatter configuration
local default_config = {
  disables = {},
  formatters = {
    rustfmt = {
      command = 'rustfmt',
      args = {
        '--emit',
        'stdout',
      },
      filetypes = {
        'rust',
      },
    },
  },
}

---@class DiffmtConfig
local config = default_config

local M = {}

---@return DiffmtConfig
function M.get_default()
  return default_config
end

---@return DiffmtConfig
function M.get()
  return config
end

---@param user_config DiffmtConfig
function M.set(user_config)
  config = vim.tbl_deep_extend('force', config, user_config)
end

return M
