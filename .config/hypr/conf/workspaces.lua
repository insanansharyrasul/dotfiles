----------------------------
--- Workspace rules
-- Monitor assignment + persistent flag combined
----------------------------

hl.workspace_rule({ workspace = "1", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", persistent = false })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1", persistent = false })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", persistent = false, layout = "scrolling" })

-- Smart Gaps (Hyprland v0.53.1+)
hl.window_rule({ name = "smart-gaps-tiled-border", match = { float = false, workspace = "w[t1]" }, border_size = 0 })
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ name = "smart-gaps-tiled-rounding", match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
