-- pull in the wezterm API
local wezterm = require('wezterm')
local launch_menu = {}

-- This will hold the configuration 
local config = wezterm.config_builder()
config.colors = { background = "#1e1e2e" }
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 1.0
config.default_prog = { 'C:/Program Files/PowerShell/7/pwsh.exe' }

config.window_frame = {
    font = wezterm.font { family = 'Roboto', weight = 'Bold' },
    font_size = 12,
    active_titlebar_bg = '#1e1e2e',
    inactive_titlebar_bg = '#1e1e2e',
}

config.colors = {
    tab_bar = {
        active_tab = {

            bg_color = '#181825',
            fg_color = "#B4BEFE"
        },
        inactive_tab = {
            bg_color = '#1e1e2e',
            fg_color = "#CDD6F4"
        },
         new_tab = {
            bg_color = '#1e1e2e',
            fg_color = "#CDD6F4"
        },
        new_tab_hover ={
            bg_color = '#1b1032',
            fg_color = '#808080',
        }
    },
}

-- Keys 
local act = wezterm.action
config.leader = { key = "a", mods="CTRL", timeout_milliseconds = 1000}

config.keys = {
    { key = "s", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain"}},
    { key = "v", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" }},
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "q", mods = "LEADER", action = act.CloseCurrentPane { confirm = false }},
    { key = "n", mods = "LEADER", action = act.ShowTabNavigator },
    { key = "t", mods = "LEADER", action = act.ShowLauncher },
}

-- config.enable_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS | TITLE | RESIZE"
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    table.insert(launch_menu, {
        label = 'PowerShell 7',
        args = { 'pwsh.exe', '-NoLogo' },
    })
   table.insert(launch_menu, {
        label = 'PowerShell',
        args = { 'PowerShell.exe', '-NoLogo' },
    })

    for _, vsvers in
        ipairs ( wezterm.glob('VisualStudio20*', 'D:/')) do
        local year = vsvers:gsub('VisualStudio', '')
        table.insert(launch_menu, {
            label = 'X64 Native Tools VS ' .. year,
            args = {
                'cmd.exe',
                '/k',
                'D:/' .. vsvers  .. '/VC/Auxiliary/Build/vcvars64.bat' },
        })
end
end

config.launch_menu = launch_menu
return config
