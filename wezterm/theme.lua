local wezterm = require 'wezterm'

config.colors = { background = "#1e1e2e" }
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.9


if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.window_decorations = "TITLE | RESIZE"
else 
    config.window_decorations = "INTEGRATED_BUTTONS | TITLE | RESIZE"
end

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
        new_tab_hover = {
            bg_color = '#1b1032',
            fg_color = '#808080',
        }
    },
}

wezterm.on('update-status', function(window)
    local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

    local color_scheme = window:effective_config().resolved_palette
    local bg = color_scheme.background
    local fg = color_scheme.foreground

    window:set_right_status(wezterm.format({
        { Background = { Color = 'none' } },
        { Foreground = { Color = bg } },
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = bg } },
        { Foreground = { Color = fg } },
        { Text = ' ' .. wezterm.hostname() .. ', WKSPC: ' .. wezterm.mux.get_active_workspace() .. '' },
    }))
end)
