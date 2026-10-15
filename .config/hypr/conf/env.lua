local HOME = os.getenv("HOME")

----------------------------
--- Environment variables ---
----------------------------

hl.env("GDK_SCALE", "1")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("XKB_DEFAULT_LAYOUT", "us")
hl.env("XKB_DEFAULT_OPTIONS", "")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_SCALE_FACTOR_ROUNDING_POLICY", "PassThrough")

hl.env("XCURSOR_SIZE", "32")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("PATH",
    HOME .. "/.local/bin:" .. HOME .. "/.cargo/bin:" .. HOME .. "/.npm-global/bin:" .. (os.getenv("PATH") or ""))
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
