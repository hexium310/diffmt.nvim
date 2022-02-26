local async = require('plenary/async')
local utils = require('utils')
local same = assert.are.same

local file = utils.get_target_file_path('init.lua')

describe('diffmt.diff to lua', function()
  describe('with default config', function ()
    before_each(function ()
      vim.cmd(([[
        silent only
        bufdo bwipeout
        edit %s
      ]]):format(file))

      utils.clear_package()
    end)

    it('should open a window with the buffer with formatted content', function ()
      local diff = require('diffmt/diff').diff
      async.util.block_on(async.wrap(diff, 1))
      same(#vim.api.nvim_list_wins(), 2)
      same(vim.api.nvim_buf_get_name(0), ('diffmt://%s'):format(file))
      same(vim.bo.filetype, 'lua')
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
      same(lines, {
        'local function aaaaa(arg)',
        '\tlocal foo = "foo"',
        '',
        '\tprint(foo)',
        'end',
        '',
        'aaaaa({})'
      })
    end)
  end)
end)
