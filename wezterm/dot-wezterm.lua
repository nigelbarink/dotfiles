-- pull in the wezterm API
local wezterm = require('wezterm')
config = wezterm.config_builder()

require "theme"
require "keys"


config.enable_tab_bar = false
-- The most common triples are:
--
-- x86_64-pc-windows-msvc - Windows
-- x86_64-apple-darwin - macOS (Intel)
-- aarch64-apple-darwin - macOS (Apple Silicon)
-- x86_64-unknown-linux-gnu - Linux
local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    table.insert(launch_menu, {
        label = 'PowerShell',
        args = { 'PowerShell.exe', '-NoLogo' },
    })
    table.insert(launch_menu, {
        label = 'PowerShell 7',
        args = { 'pwsh.exe', '-NoLogo' },
    })
    table.insert(launch_menu, {
        label = "Developer PowerShell",
        args = {
            'pwsh.exe',
            '-noe',
            '-c',
            '&{Import-Module "C:/Program Files (x86)/Microsoft Visual Studio/18/BuildTools/Common7/Tools/Microsoft.VisualStudio.DevShell.dll";Enter-VsDevShell 6c43edf9 };wezterm cli set-tab-title \'Developer Powershell\''
        },
        cwd = 'G:/git'
    })


    table.insert(launch_menu, {
        label = "Conda PowerShell",
        args = {
            'pwsh.exe',
            '-noe',
            '-c',
            '& \'C:/Users/nigel/miniconda3/shell/condabin/conda-hook.ps1\'; conda activate base '
        },
        cwd = 'G:/git/Machine Learning'
    })

    for _, vsvers in
    ipairs(wezterm.glob('VisualStudio20*', 'D:/')) do
        local year = vsvers:gsub('VisualStudio', '')
        table.insert(launch_menu, {
            label = 'X64 Native Tools VS ' .. year,
            args = {
                'cmd.exe',
                '/k',
                'D:/' .. vsvers .. '/VC/Auxiliary/Build/vcvars64.bat' },
        })
    end
end

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = { 'C:/Program Files/Powershell/7/pwsh.exe' }
else
    config.default_prog = { '/usr/bin/bash' }
end


config.launch_menu = launch_menu
config.window_close_confirmation = "NeverPrompt"
return config
