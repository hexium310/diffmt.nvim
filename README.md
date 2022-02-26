# diffmt.nvim

Neovim plugin that opens formatted content by formatter in diff window

<img width="1215" alt="image" src="https://user-images.githubusercontent.com/10758173/155855643-59409f7e-263c-4c00-9b3b-f5b1abaa8b59.png">

## Motivation

There are formatters for programming languages, and they are useful.
However even if we want not to use some rules, most formatters such as `rustfmt` and `StyLua` doesn't have the ability to disable some of their rules.
In this case, we had to reluctantly use formatter with all rules or stop use of formatter.
This plugin opens the formatted content in diff window (`:h diff`) so that makes it easy to cherry-pick changes by formatting, e.g. apply reordering imports in rust.

## Installation

Use package manager you use.
For dein:

```vim
call dein#add('hexium310/diffmt.nvim')
```

## Usage

You can use it if you don't need to customize configuration.
Open a target file to the buffer then execute following command:

```lua
lua require('diffmt').diff()
```

Note that it will be formatted against not an actual file but the content in the current buffer.

### Customization

This is the default configuration, a passed configuration will be extended based on default:

```lua
require('diffmt').setup({
  -- Commands you dont't want to execute
  disables = {},
  -- Pairs of command and formatter configuration
  formatters = {
    rustfmt = {
      -- Name or path for an executable command
      command = 'rustfmt',
      -- Command arguments. Specify arguments to read the content from standart input and emit all content in the file to the standard output after formatted
      args = {
        '--emit',
        'stdout',
      },
      -- Filetypes in which the command will be executed
      filetypes = {
        'rust',
      },
    },
    stylua = {
      command = 'stylua',
      args = {
        '-',
      },
      filetypes = {
        'lua',
      },
    },
  },
})
```

You can use add unsupported formatters:

```lua
{
  formatters = {
    prettier = {
      command = 'npx',
      args = {
        'prettier',
        '--parser',
        'babel',
      },
      filetypes = {
        'javascript',
        'javascriptreact',
      },
    },
  },
}
```

Also you can create a pull request or an issue to add support.

## Supported formatters

- [rustfmt]
- [StyLua]

[rustfmt]: https://github.com/rust-lang/rustfmt
[StyLua]: https://github.com/JohnnyMorganz/StyLua
