local devicons = require('nvim-web-devicons')

local colors = {
  black = '#282828',
  white = '#ebdbb2',
  red = '#fb4934',
  green = '#b8bb26',
  blue = '#83a598',
  yellow = '#fe8019',
  gray = '#b7ab99',
  darkgray = '#3c3836',
  lightgray = '#524B47',
}

local gruvbox_dark_theme = {
  normal = {
    a = {bg = colors.gray, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.darkgray, fg = colors.gray},
  },
  insert = {
    a = {bg = colors.blue, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.darkgray, fg = colors.gray},
  },
  visual = {
    a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.darkgray, fg = colors.gray},
  },
  replace = {
    a = {bg = colors.red, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.darkgray, fg = colors.gray},
  },
  command = {
    a = {bg = colors.green, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.darkgray, fg = colors.gray},
  },
  inactive = {
    a = {bg = colors.darkgray, fg = colors.gray, gui = 'bold'},
    b = {bg = colors.darkgray, fg = colors.gray},
    c = {bg = colors.darkgray, fg = colors.gray},
  },
}

local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
  self.status = ''
  self:apply_highlights(default_highlight)
  return self.status
end

local space = require('lualine.component'):extend()
function space:draw(default_highlight)
  self.status = ' '
  self:apply_highlights(default_highlight)
  return self.status
end

local shown_bufs_start = 1
local shown_bufs_end = 1
local prev_bufs_count = 0
local prev_buffer_state = {
  bufnr = 1,
  modified = false,
}
local prev_output = ''
local prev_max_width = vim.o.columns
local cur_buf_index = 1

function calc_buf_display_len(buffer)
  return (4 + #buffer.name + (buffer.modified and 2 or 0) + 3)
end

function max_bufs_in_range(first, last, step, buffers, start_total_length)
  local total_length = start_total_length
  for i = first, last, step do
    total_length = total_length + calc_buf_display_len(buffers[i])
    last = i

    if total_length > vim.o.columns then
      total_length = total_length - calc_buf_display_len(buffers[i])
      last = last - step
      break
    end
  end

  return last, total_length
end

require('lualine').setup({
  options = {
    theme = gruvbox_dark_theme,
    always_divide_middle = false,
    refresh = {statusline = 300},
    globalstatus = true,
  },

  sections = {
    lualine_a = {},

    lualine_b = {
      {empty, color = {bg = 'none'}},
      {
        function()
          local mode_color = string.format('#%06x',
            vim.api.nvim_get_hl(0, {name = 'lualine_a' .. require('lualine.highlight').get_mode_suffix(), link = false}).bg
          )

          local current_hl_color = vim.api.nvim_get_hl(0, {name = 'lualine_mode_border', link = false}).fg
          if not current_hl_color or
             (current_hl_color and
              string.format('#%06x', current_hl_color) ~= mode_color) then
            vim.api.nvim_set_hl(0, 'lualine_mode_border', {
              fg = mode_color,
              bg = 'none',
            })
            vim.api.nvim_set_hl(0, 'lualine_mode_icon', {
              fg = '#1d2021',
              bg = mode_color,
            })
            vim.api.nvim_set_hl(0, 'lualine_mode_mode', {
              fg = mode_color,
              bg = '#524B47',
            })
          end

          return '%#lualine_mode_border#%#lualine_mode_icon# %#lualine_mode_mode# ' .. require('lualine.utils.mode').get_mode()
        end,
        separator = {left = '', right = ''},
        padding = {left = 0, right = 0},
      },
      {space, color = {bg = colors.darkgray}},
      {
        'filename',
        newfile_status = true,
        path = 1,
        symbols = {
          modified = '󰑊',
          readonly = '',
          unnamed = '[No Name]',
          newfile = '󰐕',
        },
        separator = {left = '', right = ''},
        padding = {left = 0, right = 0},
        fmt = function(str)
          local filename = vim.fs.basename(vim.api.nvim_buf_get_name(0))
          local icon, icon_color = devicons.get_icon_color(filename, require('telescope.utils').file_extension(filename), {default = false})
          if not icon then
            icon, icon_color = devicons.get_icon_color_by_filetype(vim.api.nvim_get_option_value('ft', {}), {default = true})
          end

          local current_hl_color = vim.api.nvim_get_hl(0, {name = 'lualine_filename_border', link = false}).fg
          if not current_hl_color or
             (current_hl_color and
             string.format('#%06x', current_hl_color) ~= icon_color) then
            vim.api.nvim_set_hl(0, 'lualine_filename_border', {
              fg = icon_color,
              bg = '#3c3836',
            })

            local r = tonumber(icon_color:sub(2, 3), 16) / 255
            local g = tonumber(icon_color:sub(4, 5), 16) / 255
            local b = tonumber(icon_color:sub(6, 7), 16) / 255
            local l = 0.2126*r + 0.7152*g + 0.0722*b

            vim.api.nvim_set_hl(0, 'lualine_filename_icon', {
              fg = l < 0.6 and '#ffffff' or '#1d2021',
              bg = icon_color,
            })
          end

          str = str:gsub('^%[packer%]', 'packer')
          str = '%#lualine_filename_border#%#lualine_filename_icon#' .. icon .. ' %#lualine_b_normal# ' .. str
          return str
        end
      },
      {space, color = {bg = colors.darkgray}},

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
          local language_servers = '%#lualine_lsp_icon#󰒓 %#lualine_lsp_clients# ' .. table.concat(unique_client_names, ', ') .. '%#lualine_b_normal#'
          return language_servers
        end,
        separator = {left = '%#lualine_lsp_border#', right = ''},
        padding = {left = 0, right = 0},
      },
      {
        'diagnostics',
        sources = {'nvim_lsp'},
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' ',
          hint = ' ',
        },
        update_in_insert = true,
        separator = {right = ''},
        padding = {left = 0, right = 0},
        fmt = function(str) if #str > 0 then return ' ' .. str end end,
      },
    },

    lualine_c = {},
    lualine_x = {},

    lualine_y = {
      {
        'branch',
        separator = {left = '%#lualine_git_border#', right = ''},
        icon = '%#lualine_git_icon#',
        fmt = function(str)
          if #str > 0 then
            return '%#lualine_git_branch# ' .. str .. '%#lualine_b_normal#'
          end
        end,
        padding = {left = 0, right = 0},
      },
      {
        'diff',
        padding = {left = 0, right = 0},
        symbols = {added = '󰌴 ', modified = '󱅄 ', removed = '󱅁 '},
        separator = {right = ''},
        fmt = function(str) if #str > 0 then return ' ' .. str end end,
      },
      {space, color = {bg = colors.darkgray}},

      {
        'encoding',
        separator = {left = '%#lualine_encoding_border#'},
        icon = '%#lualine_encoding_icon#',
        fmt = function(str)
          if #str > 0 then
            return '%#lualine_encoding_type# ' .. str .. '%#lualine_b_normal#'
          end
        end,
        padding = {left = 0, right = 0},
      },
      {
        'fileformat',
        symbols = {
          unix = ' unix',
          dos = ' dos',
          mac = ' mac',
        },
        separator = {left = '', right = ''},
        fmt = function(str)
          local variant = str:find('unix') and 'unix' or 'non_unix'

          if #vim.bo.fileencoding > 0 then
            str = ' %#lualine_section_separator#%#lualine_b_normal# %#lualine_fileformat_type_' .. variant .. '#' .. str
          else
            str = string.format(
              '%%#lualine_fileformat_border_%s#%%#lualine_fileformat_icon_%s#%s %%#lualine_fileformat_type_%s#%s',
              variant,
              variant,
              str:sub(1, 3),
              variant,
              str:sub(4, -1)
            )
          end

          if #vim.bo.filetype > 0 then
            str = str .. ' %#lualine_section_separator#%#lualine_b_normal# '
          end

          return str
        end,
        padding = {left = 0, right = 0}
      },
      {
        'filetype',
        separator = {right = ''},
        padding = {left = 0, right = 0},
      },
      {space, color = {bg = colors.darkgray}},

      {
        function()
          return '%#lualine_progress_progress# %P/%L%#lualine_b_normal#'
        end,
        separator = {left = '%#lualine_progress_border#', right = ''},
        icon = '%#lualine_progress_icon#',
        padding = {left = 0, right = 0},
      },
      {space, color = {bg = colors.darkgray}},
      {
        'location',
        separator = {left = '%#lualine_loc_border#', right = ''},
        icon = '%#lualine_loc_icon#󰙏',
        fmt = function(str) return '%#lualine_loc_loc# ' .. str:gsub('%s+', '') end,
        padding = {left = 0, right = 0},
      },
      {empty, color = {bg = 'none'}},
    },

    lualine_z = {},
  },

  tabline = {
    lualine_c = {
      {
        function()
          local cur_bufnr = vim.api.nvim_get_current_buf()
          local bufnrs = vim.api.nvim_list_bufs()
          local buffers = {}
          for _, bufnr in ipairs(bufnrs) do
            if vim.fn.buflisted(bufnr) == 1 then
              table.insert(buffers, {
                bufnr = bufnr,
                name = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr)),
                modified = vim.api.nvim_get_option_value('modified', {buf = bufnr}),
                active = bufnr == cur_bufnr,
              })

              if bufnr == cur_bufnr then
                cur_buf_index = #buffers
              end
            end
          end

          if #buffers == 0 then
            return ''
          end

          local should_redraw =
            prev_bufs_count ~= #buffers or      -- a buffer was deleted or added
            cur_buf_index < shown_bufs_start or -- cur buf is before the window
            vim.o.columns ~= prev_max_width or  -- neovim resized
            cur_buf_index > shown_bufs_end      -- cur buf is after the window

          if cur_buf_index < shown_bufs_start or vim.o.columns ~= prev_max_width then
            shown_bufs_start = cur_buf_index
            shown_bufs_end, total_length = max_bufs_in_range(shown_bufs_start, #buffers, 1, buffers, 0)
            if total_length < vim.o.columns then
              shown_bufs_start, _ = max_bufs_in_range(shown_bufs_start - 1, 1, -1, buffers, total_length)
            end
          elseif cur_buf_index > shown_bufs_end then
            shown_bufs_end = cur_buf_index
            shown_bufs_start, total_length = max_bufs_in_range(shown_bufs_end, 1, -1, buffers, 0)
            if total_length < vim.o.columns then
              shown_bufs_end, _ = max_bufs_in_range(shown_bufs_end + 1, #buffers, 1, buffers, total_length)
            end
          elseif prev_bufs_count ~= #buffers then
            shown_bufs_end, total_length = max_bufs_in_range(shown_bufs_start, #buffers, 1, buffers, 0)
            if total_length < vim.o.columns then
              shown_bufs_start, _ = max_bufs_in_range(shown_bufs_start - 1, 1, -1, buffers, total_length)
            end
          end

          if should_redraw then
            local total_length = 0
            for i = shown_bufs_start, shown_bufs_end do
              total_length = total_length + calc_buf_display_len(buffers[i])
            end

            local distance_from_start = cur_buf_index - shown_bufs_start
            local distance_from_end = shown_bufs_end - cur_buf_index

            if shown_bufs_start ~= 1 then
              total_length = total_length + 7
              if total_length > vim.o.columns then
                if distance_from_start < distance_from_end then
                  total_length = total_length - calc_buf_display_len(buffers[shown_bufs_end])
                  shown_bufs_end = shown_bufs_end - 1
                else
                  total_length = total_length - calc_buf_display_len(buffers[shown_bufs_start])
                  shown_bufs_start = shown_bufs_start + 1
                end
              end
            end

            if shown_bufs_end ~= #buffers and total_length + 7 > vim.o.columns then
              if distance_from_start < distance_from_end then
                shown_bufs_end = shown_bufs_end - 1
              else
                shown_bufs_start = shown_bufs_start + 1
              end
            end
          end

          should_redraw =
            should_redraw or
            buffers[cur_buf_index].bufnr ~= prev_buffer_state.bufnr or
            buffers[cur_buf_index].modified ~= prev_buffer_state.modified

          prev_bufs_count = #buffers
          prev_buffer_state = buffers[cur_buf_index]
          prev_max_width = vim.o.columns

          if should_redraw then
            local output = ''

            if shown_bufs_start ~= 1 then
              output = '%#lualine_buffers_hidden_border#%#lualine_buffers_hidden#  %#lualine_buffers_hidden_border#%#lualine_c_normal# '
            end

            for i = shown_bufs_start, shown_bufs_end do
              local buffer = buffers[i]

              local icon, icon_hl_group = devicons.get_icon(buffer.name, require('telescope.utils').file_extension(buffer.name), {default = false})
              if not icon then
                icon, icon_hl_group = devicons.get_icon_by_filetype(vim.api.nvim_get_option_value('ft', {buf = buffer.bufnr}), {default = true})
              end

              local icon_hl = {
                fg = string.format('#%06x', vim.api.nvim_get_hl(0, {name = icon_hl_group, link = false}).fg),
                bg = '#524B47',
              }
              vim.api.nvim_set_hl(0, 'lualine_buffers_' .. icon_hl_group, icon_hl)

              output = output .. string.format(
                '%%#lualine_section_border%s#%%#%s# %%#%s#%s%%#%s# %s%s %%#lualine_section_border%s#%%#lualine_c_normal# ',
                buffer.active and ((i == 1) and '_active_bg_none' or '_active') or ((i == 1) and '_bg_none' or ''),
                buffer.active and 'lualine_a_normal' or 'lualine_b_normal',
                buffer.active and 'lualine_a_normal' or 'lualine_buffers_' .. icon_hl_group,
                icon,
                buffer.active and 'lualine_a_normal' or 'lualine_b_normal',
                buffer.name,
                buffer.modified and ' 󰑊' or '',
                buffer.active and '_active' or ''
              )
            end

            if shown_bufs_end ~= #buffers then
              output = output .. '%#lualine_buffers_hidden_border#%#lualine_buffers_hidden#  %#lualine_buffers_hidden_border#%#lualine_c_normal# '
            end

            output = output:sub(1, -2)
            prev_output = output

            return output
          else
            return prev_output
          end
        end,
        separator = {},
        padding = {},
      },
    },
  },
})
