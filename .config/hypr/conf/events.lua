--------------------------
--- Event notifications ---
--------------------------

hl.on("keybinds.submap", function(name)
    if name == "" then return end
    hl.notification.create({ text = "Submap: " .. name .. " (Esc to exit)", timeout = 3000, icon = "info" })
end)

hl.on("monitor.added", function(m)
    hl.notification.create({ text = "Monitor connected: " .. m.name, timeout = 4000, icon = "ok" })
end)

hl.on("monitor.removed", function(m)
    hl.notification.create({ text = "Monitor disconnected: " .. m.name, timeout = 4000, icon = "warn" })
end)
