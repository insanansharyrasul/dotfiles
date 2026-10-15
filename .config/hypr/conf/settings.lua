hl.config({
    debug = {
        disable_logs = true,
    },
})

--------------------------
--- Input configuration ---
--------------------------

hl.config({
    input = {
        kb_layout     = "us",
        follow_mouse  = 1,
        touchpad      = {
            natural_scroll       = false,
            tap_to_click         = true,
            drag_lock            = true,
            disable_while_typing = true,
            scroll_factor        = 0.8,
            clickfinger_behavior = true,
        },
        sensitivity   = -0.2,
        repeat_rate   = 50,
        repeat_delay  = 200,
        accel_profile = "adaptive",
    },
})

-----------------------------
--- General configuration ---
-----------------------------

hl.config({
    general = {
        gaps_in       = 5,
        gaps_out      = 5,

        border_size   = 1,

        col           = {
            active_border   = "rgba(ff9c40ff)",
            inactive_border = "rgba(161a24aa)",
        },

        layout        = "dwindle",
        allow_tearing = false,
    },
})

-----------------
--- Decoration ---
-----------------

hl.config({
    decoration = {
        rounding = 10,

        blur = {
            enabled = false,
            size    = 3,
            passes  = 1,
        },

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
    },
})

------------------
--- Animations ---
------------------

hl.config({ animations = { enabled = false } })
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 7, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

--------------------
--- Master layout ---
--------------------
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "slave",
    },
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

-----------------
--- Gestures ---
-----------------

-- 3-finger horizontal swipe for workspace navigation (inversion handled by workspace_swipe_touch_invert below)
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", mods = "SUPER", action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "down", mods = "ALT", action = "close" })
hl.gesture({ fingers = 3, direction = "up", action = function() hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+") end })
hl.gesture({
    fingers = 3,
    direction = "down",
    action = function()
        hl.exec_cmd(
            "wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-")
    end
})

hl.config({
    gestures = {
        workspace_swipe_cancel_ratio = 0.15,
        workspace_swipe_distance     = 100,
        workspace_swipe_touch_invert = true,
        workspace_swipe_invert       = false,
    },
})

-----------
--- Misc ---
-----------

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        vrr                     = 0,
        disable_autoreload      = false,
        enable_swallow = true,
        swallow_regex = '^Alacritty$'
    },
})
