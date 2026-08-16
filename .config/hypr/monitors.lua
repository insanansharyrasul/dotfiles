hl.monitor({
  output = "eDP-1",
  -- mode = "highrr",
  mode = "2880x1800@90",
  position = "auto-left",
  scale = 2,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "highres",
  position = "auto-right",
  scale = 1,
  -- mirror = "eDP-1"
})
