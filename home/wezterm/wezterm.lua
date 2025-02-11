local wezterm = require("wezterm")

-- Colors
local background = "#121212"
local foreground = "#d5d5d5"
local highlight = "#73b3e7"

-- -- Center tab bar
wezterm.on("update-status", function(window)
  window:set_right_status(wezterm.format({
    { Foreground = { Color = foreground } },
    { Text = " " .. wezterm.strftime("%H:%M") },
  }))
end)

wezterm.on("augment-command-palette", function()
  return {
    {
      brief = "Rename tab",
      icon = "md_rename_box",
      action = wezterm.action.PromptInputLine({
        description = "Enter new name for tab",
        action = wezterm.action_callback(function(window, _, name)
          if name then
            window:active_tab():set_title(name)
          end
        end),
      }),
    },
  }
end)

local function keybinds()
  local act = wezterm.action

  local keys = {
    {
      key = "d",
      mods = "CMD",
      action = act.CloseCurrentPane({ confirm = true }),
    },
    {
      key = "d",
      mods = "CMD|SHIFT",
      action = act.CloseCurrentTab({ confirm = true }),
    },
    {
      key = "n",
      mods = "CMD",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "s",
      mods = "CMD",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "v",
      mods = "CMD",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "h",
      mods = "CMD",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "k",
      mods = "CMD",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "l",
      mods = "CMD",
      action = act.ActivatePaneDirection("Right"),
    },
    {
      key = "j",
      mods = "CMD",
      action = act.ActivatePaneDirection("Down"),
    },
    {
      key = "H",
      mods = "CMD",
      action = act.ActivateTabRelative(-1),
    },
    {
      key = "L",
      mods = "CMD",
      action = act.ActivateTabRelative(1),
    },
    {
      key = "p",
      mods = "CMD",
      action = act.ActivateCommandPalette,
    },
    {
      key = "z",
      mods = "CMD",
      action = act.TogglePaneZoomState,
    },
    {
      key = "c",
      mods = "CMD",
      action = act.CopyTo("Clipboard"),
    },
    {
      key = "c",
      mods = "CTRL|SHIFT",
      action = act.CopyTo("Clipboard"),
    },
    {
      key = "v",
      mods = "CTRL|SHIFT",
      action = act.PasteFrom("Clipboard"),
    },
    {
      key = "X",
      mods = "CMD",
      action = act.ActivateCopyMode,
    },
    {
      key = "UpArrow",
      mods = "CMD|SHIFT",
      action = act.ScrollByPage(-1),
    },
    {
      key = "DownArrow",
      mods = "CMD|SHIFT",
      action = act.ScrollByPage(1),
    },
    {
      key = "UpArrow",
      mods = "CMD",
      action = act.ScrollByLine(-1),
    },
    {
      key = "DownArrow",
      mods = "CMD",
      action = act.ScrollByLine(1),
    },
    {
      key = "UpArrow",
      mods = "CMD|ALT",
      action = act.ScrollToTop,
    },
    {
      key = "DownArrow",
      mods = "CMD|ALT",
      action = act.ScrollToBottom,
    },
    {
      key = "x",
      mods = "CMD",
      action = act.PaneSelect({
        mode = "SwapWithActiveKeepFocus",
      }),
    },
  }

  for i = 1, 9 do
    table.insert(keys, { key = tostring(i), mods = "CMD", action = act.ActivateTab(i - 1) })
  end

  return keys
end

return {
  -- Font
  font = wezterm.font("Berkeley Mono"),
  font_size = 15.0,

  -- Tab bar
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  show_new_tab_button_in_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,

  -- Window
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },

  -- Colors
  colors = {
    foreground = foreground,
    background = background,

    cursor_bg = foreground,
    cursor_fg = background,
    cursor_border = foreground,

    selection_bg = "#323232", -- Same as Neovim's
    selection_fg = foreground,

    ansi = {
      "#121212",
      "#e77171",
      "#a1bf78",
      "#dbb774",
      "#73b3e7",
      "#d390e7",
      "#5ebaa5",
      "#3e4249",
    },
    brights = {
      "#88909f",
      "#e77171",
      "#d5d5d5",
      "#dbb774",
      "#73b3e7",
      "#d390e7",
      "#5ebaa5",
      "#d5d5d5",
    },

    tab_bar = {
      background = background,
      active_tab = {
        bg_color = highlight,
        fg_color = background,
      },
      inactive_tab = {
        bg_color = background,
        fg_color = foreground,
      },
    },
  },

  -- Keys
  disable_default_key_bindings = true,
  keys = keybinds(),
  enable_kitty_keyboard = true,

  -- Misc
  force_reverse_video_cursor = true,
  term = "wezterm",
}
