local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

-- Colors
local background = "#121212"
local highlight = "#ff265c"

-- -- Center tab bar
wezterm.on("update-status", function(window)
  local tabs = window:mux_window():tabs()
  local mid_width = 0
  for idx, tab in ipairs(tabs) do
    local title = tab:get_title()
    mid_width = mid_width + math.floor(math.log(idx, 10)) + 1
    mid_width = mid_width + 2 + #title + 1
  end
  local tab_width = window:active_tab():get_size().cols
  local max_left = tab_width / 2 - mid_width / 2

  window:set_left_status(wezterm.pad_left(" ", max_left))

  local date = wezterm.strftime("%H:%M")
  window:set_right_status(wezterm.format({
    { Text = " " .. date },
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

wezterm.on("gui-startup", function()
  local lucas_tab, lucas_pane, window = mux.spawn_window({ cwd = wezterm.home_dir .. "/src/lucas-firmware-dlc32" })
  lucas_pane:split({ cwd = wezterm.home_dir .. "/src/lucas-firmware" })
  lucas_tab:set_title("lucas")

  local tester_tab, tester_pane, _ = window:spawn_tab({ cwd = wezterm.home_dir .. "/src/lucas-tester-pwa" })
  tester_pane:split({ cwd = wezterm.home_dir .. "/src/lucas_tester" })
  tester_tab:set_title("tester")

  local sys_tab, sys_pane, _ = window:spawn_tab({ cwd = wezterm.home_dir .. "/.config/system" })
  sys_pane:split({ cwd = wezterm.home_dir .. "/.config/wezterm" })
  sys_tab:set_title("sys")

  local puc_tab, _, _ = window:spawn_tab({ cwd = wezterm.home_dir .. "/puc" })
  puc_tab:set_title("puc")
end)

local keys = {
  {
    key = "w",
    mods = "CMD",
    action = act.CloseCurrentPane({ confirm = true }),
  },
  {
    key = "s",
    mods = "CMD",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "S",
    mods = "CMD",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
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
    key = "t",
    mods = "CMD",
    action = act.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "c",
    mods = "CMD",
    action = act.CopyTo("Clipboard"),
  },
  {
    key = "v",
    mods = "CMD",
    action = act.PasteFrom("Clipboard"),
  },
  {
    key = "X",
    mods = "CMD",
    action = act.ActivateCopyMode,
  },
}

for i = 1, 9 do
  table.insert(keys, { key = tostring(i), mods = "CMD", action = act.ActivateTab(i - 1) })
end

return {
  -- Font
  font = wezterm.font("BerkeleyMono Nerd Font Mono"),
  font_size = 15.0,

  -- Tab bar
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  show_new_tab_button_in_tab_bar = false,

  -- Window
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },

  -- Colors
  colors = {
    background = background,
    tab_bar = {
      background = background,
      active_tab = {
        bg_color = highlight,
        fg_color = background,
      },
      inactive_tab = {
        bg_color = background,
        fg_color = "c0c0c0",
      },
    },
  },

  -- Keys
  disable_default_key_bindings = true,
  keys = keys,

  -- Misc
  force_reverse_video_cursor = true,

  term = "wezterm",
}
