--- Hyprland entry config (Hyprland 0.55+, Lua) ---
--- Each require is an isolated scope: an error in one file won't kill the others. ---

require("monitors")

-- Fallback for any output not listed in monitors.lua
hl.monitor({
    output = "",
    mode = "highres",
    scale = 2,
})

require("conf.settings")
require("conf.env")
require("conf.workspaces")
require("conf.rules")
require("conf.binds")
require("conf.autostart")
require("conf.events")
