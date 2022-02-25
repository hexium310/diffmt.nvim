local config = require('diffmt/config')
local diff = require('diffmt/diff')

local M = {}

function M.diff()
  diff.diff(function () end)
end

---@param user_config DiffmtConfig
function M.setup(user_config)
  config.set(user_config)
end

return M
