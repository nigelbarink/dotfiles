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
    -- Developer PowerShell: use ProgramFiles(x86) env var for portability
    local program_files_x86 = os.getenv("ProgramFiles(x86)") or "C:/Program Files (x86)"
    local dev_shell_dll = program_files_x86 .. "/Microsoft Visual Studio/18/BuildTools/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"
    local git_root = os.getenv("WEZTERM_GIT_ROOT") or "G:/git"
    table.insert(launch_menu, {
        label = "Developer PowerShell",
        args = {
            'pwsh.exe',
            '-noe',
            '-c',
            '&{Import-Module "' .. dev_shell_dll .. '";Enter-VsDevShell 6c43edf9 };wezterm cli set-tab-title \'Developer Powershell\''
        },
        cwd = git_root
    })

    local user_profile = os.getenv("USERPROFILE") or wezterm.home_dir
    table.insert(launch_menu, {
        label = "Conda PowerShell",
        args = {
            'pwsh.exe',
            '-noe',
            '-c',
            '& \'' .. user_profile .. '/miniconda3/shell/condabin/conda-hook.ps1\'; conda activate base '
        },
        cwd = git_root .. "/Machine Learning"
    })

    -- Search for Visual Studio installs on D: then C: (portable across drive layouts)
    local vs_roots = { "D:/", "C:/" }
    for _, root in ipairs(vs_roots) do
        for _, vsvers in ipairs(wezterm.glob('VisualStudio20*', root)) do
            local year = vsvers:gsub('VisualStudio', '')
            table.insert(launch_menu, {
                label = 'X64 Native Tools VS ' .. year,
                args = {
                    'cmd.exe',
                    '/k',
                    root .. vsvers .. '/VC/Auxiliary/Build/vcvars64.bat' },
            })
        end
    end
end

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    -- Prefer PowerShell 7 at standard location; fall back to pwsh on PATH if not found
    local pwsh_path = "C:/Program Files/PowerShell/7/pwsh.exe"
    local f = io.open(pwsh_path, "r")
    if f then f:close(); config.default_prog = { pwsh_path } else config.default_prog = { 'pwsh.exe', '-NoLogo' } end
else
    config.default_prog = { '/usr/bin/bash' }
end


config.launch_menu = launch_menu
config.window_close_confirmation = "NeverPrompt"
return config
