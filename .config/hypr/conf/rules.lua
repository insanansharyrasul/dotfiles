---------------------
--- Window rules ---
---------------------
hl.window_rule({ match = { class = "^(pop-up)$" }, float = true })
hl.window_rule({ match = { class = "^(bubble)$" }, float = true })
hl.window_rule({ match = { class = "^(task_dialog)$" }, float = true })
hl.window_rule({ match = { class = "^(Preferences)$" }, float = true })
hl.window_rule({ match = { class = "^(code)$", title = "^(Open Folder)$" }, float = true })
hl.window_rule({ match = { title = "^(All Files)$" }, float = true })
hl.window_rule({ match = { class = "^(gnome-calendar)$" }, float = true })
hl.window_rule({ match = { class = "^(dialog)$" }, float = true })
hl.window_rule({ match = { class = "^(menu)$" }, float = true })
hl.window_rule({ match = { class = "^(Organizer)$" }, float = true })
hl.window_rule({ match = { class = "^(About)$" }, float = true })
hl.window_rule({ match = { class = "^(toolbox)$" }, float = true })
hl.window_rule({ match = { class = "^(page-info)$" }, float = true })
hl.window_rule({ match = { class = "^(webconsole)$" }, float = true })
hl.window_rule({ match = { class = "^(floating_con)$" }, float = true })
hl.window_rule({ match = { class = "^(Emulator)$" }, float = true })
hl.window_rule({ match = { class = "^(Emulator)$" }, float = true, monitor = "eDP-1" })
hl.window_rule({ match = { class = "^(woomer)$" }, float = true, center = true, fullscreen = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true })
hl.window_rule({ match = { class = "^zoom$" }, float = true })

-- File picker dialogs
hl.window_rule({ match = { title = "^(Open File)$" }, float = true })
hl.window_rule({ match = { title = "^(Open Folder)$" }, float = true })
hl.window_rule({ match = { title = "^(Save File)$" }, float = true })
hl.window_rule({ match = { title = "^(Save As)$" }, float = true })
hl.window_rule({ match = { class = "^nemo$", title = "Properties" }, float = true })

-- Generic dialog patterns
hl.window_rule({ match = { class = "^(.*)$", title = "^(.*[Ee]rror.*)$" }, float = true })
hl.window_rule({ match = { class = "^(.*)$", title = "^(.*[Ww]arning.*)$" }, float = true })

hl.window_rule({ match = { class = "zoom", title = "Zoom Workplace" }, no_initial_focus = true })
hl.window_rule({ match = { class = "zoom", title = "menu window" }, no_initial_focus = true })

hl.window_rule({ name = "float-no-border", match = { float = true }, border_size = 0 })

--- Animation for specific apps
hl.window_rule({ match = { class = "^(pop-up)$" }, animation = "popin" })
hl.window_rule({ match = { class = "^(task_dialog)$" }, animation = "popin" })
hl.window_rule({ match = { class = "^(dialog)$" }, animation = "popin" })
hl.window_rule({ match = { class = "^(woomer)$" }, animation = "popin" })

--- No screen share
-- hl.window_rule({ match = { class = "^(firefox)$" }, no_screen_share = true })

------------------
--- Layer rules ---
------------------

hl.layer_rule({ match = { namespace = "wofi" }, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "wofi" }, ignore_alpha = 0.5 })
-- hl.layer_rule({ match = { namespace = "notifications" }, no_screen_share = true })
