local wezterm = require('wezterm')

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Gruvbox Dark (Gogh)'
config.colors = {
  foreground = '#f8f8f2',
  background = '#1d2021',

  cursor_bg = '#8ec07c',

  selection_fg = '#1d2021',
  selection_bg = '#ebdbb2',

  ansi = {
    '#1d2021',
    '#cc241d',
    '#98971a',
    '#d79921',
    '#458588',
    '#b16286',
    '#689d6a',
    '#a89984',
  },

  brights = {
    '#928374',
    '#fb4934',
    '#b8bb26',
    '#fabd2f',
    '#83a598',
    '#d3869b',
    '#8ec07c',
    '#ebdbb2',
  },

  tab_bar = {
    background = '#3c3836',
  },
}

config.window_background_opacity = 0.7

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false

function basename(s)
  return string.gsub(s, '(/.*)/(.*)', '%2')
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    if tab.is_active or hover then
      background = '#b7ab99'
      foreground = '#282828'
    else
      background = '#524b47'
      foreground = '#ebdbb2'
    end

    local title = ' ' .. basename(tab.active_pane.foreground_process_name) .. ' '
    title = wezterm.truncate_right(title, max_width - 1)

    return {
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = '#3c3836' } },
      { Foreground = { Color = '#3c3836' } },
      { Text = ' ' },
    }
  end
)

config.window_padding = {
  top = 0,
  right = 0,
  bottom = 0,
  left = 0,
}

config.enable_scroll_bar = false
config.term = 'wezterm'
config.scrollback_lines = 1000
config.check_for_updates = false
config.window_close_confirmation = 'NeverPrompt'
config.audible_bell = 'Disabled'
config.detect_password_input = false
config.alternate_buffer_wheel_scroll_speed = 3
config.default_cursor_style = 'SteadyBlock'
config.hide_mouse_cursor_when_typing = false
config.cursor_blink_rate = 0
config.canonicalize_pasted_newlines = 'LineFeed'

config.adjust_window_size_when_changing_font_size = false
config.allow_square_glyphs_to_overflow_width = 'Always'
config.bold_brightens_ansi_colors = 'No'
config.warn_about_missing_glyphs = false
config.line_height = 0.9

config.font_size = 14
config.font = wezterm.font_with_fallback({
  'JetBrainsMono Nerd Font',
})

config.font_rules = {
  {
    intensity = 'Bold',
    italic = false,
    font = wezterm.font_with_fallback({
      {
        family = 'JetBrainsMono Nerd Font',
        weight = 'ExtraBold',
        style = 'Normal',
      }
    }),
  },

  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font_with_fallback({
      {
        family = 'JetBrainsMono Nerd Font',
        weight = 'ExtraBold',
        style = 'Italic',
      }
    }),
  },
}

config.keys = {
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'Space',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateCopyMode,
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.QuickSelectArgs({
      label = 'open url',
      patterns = {
        'https?://\\S+',
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.open_with(url)
      end),
    }),
  },
  {
    key = 'g',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyMode({ MoveBackwardZoneOfType = 'Output' }),
  }
}

config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    action = wezterm.action.ScrollByLine(-3),
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    action = wezterm.action.ScrollByLine(3),
  },
}

return config
