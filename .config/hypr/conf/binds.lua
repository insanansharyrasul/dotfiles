local mainMod = "SUPER"

---------------------
--- Key bindings ---
---------------------

-- Application launches
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("alacritty -e ranger"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("nemo"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("code --ozone-platform-hint=wayland"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/.config/eww/scripts/toggle-eww.sh"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("gnome-system-monitor"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("~/.local/bin/c-woomer"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("alacritty -e nvim"))

-- Terminal and basic Hyprland controls
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + D",
    hl.dsp.exec_cmd('wofi --show drun --style "$HOME/.config/wofi/wofi-font.css" --width 650 --height 500'))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exit())

-- Volume controls
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -10%"), { repeating = true })
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +10%"), { repeating = true })
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("pactl set-source-mute 85 toggle"))

-- Power menu
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("~/.config/wofi/power.sh"))

-- Lock screen
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))

-- Screenshots - using grim/slurp (more reliable)
hl.bind("Print", hl.dsp.exec_cmd('$HOME/.config/hypr/scripts/screenshot-full.sh'))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd('$HOME/.config/hypr/scripts/screenshot-window.sh'))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/screenshot-region.sh"))

-- OCR
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd('grim -g "$(slurp)" - | tesseract stdin stdout | wl-copy'))

-- Color Picker
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd('wl-color-picker'))

-- Screen record
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd('$HOME/.config/hypr/scripts/record-screen.sh'))
hl.bind(mainMod .. " + CTRL + SHIFT + R", hl.dsp.exec_cmd('$HOME/.config/hypr/scripts/record-screen-desktop-audio.sh'))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd('$HOME/.config/hypr/scripts/record-screen-gif.sh'))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move windows with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Move windows with mainMod + SHIFT + hjkl
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- key 0 maps to workspace 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- Workspace navigation with Ctrl+Alt
hl.bind("CTRL + ALT + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + ALT + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("CTRL + ALT + H", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + ALT + L", hl.dsp.focus({ workspace = "e+1" }))

-- Move window to workspace and follow
hl.bind("CTRL + ALT + SHIFT + H", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("CTRL + ALT + SHIFT + L", hl.dsp.window.move({ workspace = "e+1" }))

-- Layout controls
hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + comma", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + period", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + Tab", function()
    local layouts = { "dwindle", "scrolling", "monocle" }
    local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
    if not workspace then return end
    local next_layout = "dwindle"
    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            next_layout = layouts[(i % #layouts) + 1]
            break
        end
    end
    if workspace.special then
        hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
    else
        hl.workspace_rule({ workspace = "name:" .. tostring(workspace.name), layout = next_layout })
    end
end)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + G", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + Space", hl.dsp.window.float())
-- hl.bind(mainMod .. " + A", hl.dsp.focus({ urgent_or_last = true }))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("alacritty -e nmtui"))

-- Scratchpad (Special workspace)
hl.bind(mainMod .. " + x", hl.dsp.window.move({ workspace = "special", follow = false }))
hl.bind(mainMod .. " + c", hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. " + semicolon", hl.dsp.window.toggle_swallow())
hl.bind(mainMod .. " + R", hl.dsp.submap("R"))

hl.define_submap("R", function()
    hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- Zoom
hl.bind(mainMod .. " + SHIFT + equal",
    hl.dsp.exec_cmd(
        "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.2')"),
    { repeating = true })
hl.bind(mainMod .. " + SHIFT + minus",
    hl.dsp.exec_cmd(
        "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.8) | if . < 1 then 1 else . end')"),
    { repeating = true })

-- Gap adjustments
hl.bind(mainMod .. " + bracketleft",
    hl.dsp.exec_cmd("hyprctl keyword general:gaps_out $(($(hyprctl getoption general:gaps_out -j | jq -r '.int') + 2))"))
hl.bind(mainMod .. " + bracketright",
    hl.dsp.exec_cmd("hyprctl keyword general:gaps_out $(($(hyprctl getoption general:gaps_out -j | jq -r '.int') - 2))"))
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("hyprctl keyword general:gaps_in 5 && hyprctl keyword general:gaps_out 0"))

-- Special function keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +10%"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -10%"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"), { repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- Mouse bindings
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
