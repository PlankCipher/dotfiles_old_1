require('lualine').setup({
  options = {
    theme = 'gruvbox_dark',
    component_separators = {left = '', right = ''},
    section_separators = {left = '', right = ''},
    always_divide_middle = false,
    refresh = {statusline = 300},
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function(str) return str:sub(1,1) end,
      },
    },
    lualine_b = {
      {
        'filetype',
        icon_only = true,
        separator = '',
        padding = {left = 1, right = 0},
      },
      {
        'filename',
        newfile_status = true,
        path = 1,
        symbols = {
          modified = '',
          readonly = '',
          unnamed = '[No Name]',
          newfile = '',
        },
      },
      {
        'branch',
        separator = '',
        icon = {''},
      },
      {
        'diff',
        padding = {left = 0, right = 1},
        symbols = {added = ' ', modified = ' ', removed = ' '},
      },
    },
    lualine_c = {
      {
        function()
          local buf_clients = vim.lsp.get_active_clients({bufnr = 0})
          if #buf_clients == 0 then
            return ''
          end

          local buf_client_names = {}
          for _, client in pairs(buf_clients) do
            table.insert(buf_client_names, client.name)
          end

          local unique_client_names = vim.fn.uniq(buf_client_names)

          local language_servers = ' ' .. table.concat(unique_client_names, ', ')

          return language_servers
        end,
      },
      {
        'diagnostics',
        sources = {'nvim_lsp'},
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' ',
          hint = ' '
        },
        update_in_insert = true,
      },
    },
    lualine_x = {
      {
        'encoding',
        icon = {''},
      },
      {
        'fileformat',
        symbols = {
          unix = ' unix',
          dos = ' dos',
          mac = ' mac',
        },
      },
      'filetype',
    },
    lualine_y = {
      {
        'progress',
        fmt = function() return '%P/%L' end,
        icon = {''},
      },
    },
    lualine_z = {
      {
        'location',
        fmt = function(str) return str:gsub("^%s+", "") end,
        icon = {''},
      },
    },
  },
  inactive_sections = {
    lualine_c = {
      {
        'filetype',
        icon_only = true,
        separator = '',
        padding = {left = 1, right = 0},
      },
      {
        'filename',
        newfile_status = true,
        path = 1,
        symbols = {
          modified = '',
          readonly = '',
          unnamed = '[No Name]',
          newfile = '',
        },
      },
    },
    lualine_x = {},
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        symbols = {
          modified = ' ',
          alternate_file = '#',
          directory = '',
        },
        mode = 2,
        max_length = vim.o.columns,
      },
    },
  },
})
