local wezterm = require 'wezterm'

local act = wezterm.action


config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    { key = "s", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "v", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "h", mods = "ALT",    action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "ALT",    action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "ALT",    action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "ALT",    action = act.ActivatePaneDirection("Right") },
    { key = "q", mods = "LEADER", action = act.CloseCurrentPane { confirm = false } },
    { key = "t", mods = "LEADER", action = act.ShowTabNavigator },
    { key = "n", mods = "LEADER", action = act.ShowLauncher },
    { key = "t", mods = "ALT",    action = act.ShowLauncherArgs { flags = "TABS|FUZZY" } },
    { key = 'w', mods = 'ALT',    action = act.ShowLauncherArgs { flags = 'WORKSPACES|FUZZY' } },
}

local function isViProcess(pane)
    return pane:get_foreground_process_name():find('n?vim') ~= nil or pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
    if isViProcess(pane) then
        window:perform_action(
        -- This should match the keybinds you set in Neovim.
            act.SendKey({ key = vim_direction, mods = 'CTRL' }),
            pane
        )
    else
        window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
    end
end
wezterm.on('ShowLauncherArgs', function(window, pane)
    wezterm.info_log 'launcher args called '
end)
wezterm.on('ActivatePaneDirection-right', function(window, pane)
    conditionalActivatePane(window, pane, 'Right', 'l')
end)
wezterm.on('ActivatePaneDirection-left', function(window, pane)
    conditionalActivatePane(window, pane, 'Left', 'h')
end)
wezterm.on('ActivatePaneDirection-up', function(window, pane)
    conditionalActivatePane(window, pane, 'Up', 'k')
end)
wezterm.on('ActivatePaneDirection-down', function(window, pane)
    conditionalActivatePane(window, pane, 'Down', 'j')
end)
