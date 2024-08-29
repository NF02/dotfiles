---------------------------------------------
-- ┃┃┃┏━┛┏━┃━┏┛┏━┛┏━┃┏┏   ┏━┛┏━┃┏━ ┏━┛┛┏━┛ --
-- ┃┃┃┏━┛┏┏┛ ┃ ┏━┛┏┏┛┃┃┃  ┃  ┃ ┃┃ ┃┏━┛┃┃ ┃ --
-- ━━┛━━┛┛ ┛ ┛ ━━┛┛ ┛┛┛┛  ━━┛━━┛┛ ┛┛  ┛━━┛ --
---------------------------------------------
local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}
config.hide_tab_bar_if_only_one_tab = true
-- config.color_scheme = 'Apathy'
config.window_background_opacity = 0.8
config.enable_scroll_bar = true
config.font = wezterm.font { family = 'Terminus', weight = 'Regular' }
config.font_size = 11.0

-- Base frame
config.window_frame = {
   font = wezterm.font { family = 'Terminus', weight = 'Regular' },
   font_size = 10.0,
   active_titlebar_bg = '#333333',
   inactive_titlebar_bg = '#ffed23',
}

config.colors = {
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = '#0b0022',

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = '#2b2042',
      -- The color of the text for the tab
      fg_color = '#c0c0c0',

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = 'Normal',

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = 'None',

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  },
}
-- keybinding
config.keys = {
  {
    key = '|',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '_',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'H',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.Search { Regex = '[a-f0-9]{6,}' },
  },
}

key_tables = {
   search_mode = {
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
      { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
      { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
      { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
      {
	 key = 'PageUp',
	 mods = 'NONE',
	 action = act.CopyMode 'PriorMatchPage',
      },
      {
	 key = 'PageDown',
	 mods = 'NONE',
	 action = act.CopyMode 'NextMatchPage',
      },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
   },
}

config.send_composed_key_when_right_alt_is_pressed = true
return config
