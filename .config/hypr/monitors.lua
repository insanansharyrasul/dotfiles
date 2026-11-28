hl.monitor({
  output = "eDP-1",
  -- mode = "highrr",
  mode = "2880x1800@60",
  position = "0x0",
  scale = 2,
  bitdepth = 10,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "highres",
  position = "auto-right",
  scale = 1,
  -- mirror = "eDP-1"
})
