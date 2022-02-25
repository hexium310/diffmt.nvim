local M = {}

function M.get_target_file_path()
  local dir = require('plenary/path'):new(debug.getinfo(2, 'S').source:sub(2)):parent():absolute()
  local file = dir .. '/main.rs'

  return file
end

function M.clear_package()
  local packages = vim.tbl_filter(function (v) return v:find("^diffmt.*$") end, vim.tbl_keys(package.loaded))

  for _, name in ipairs(packages) do
    package.loaded[name] = nil
  end
end

return M
