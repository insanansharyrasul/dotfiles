hl.monitor({
  output = "eDP-1",
  -- mode = "highrr",
  mode = "2880x1800@90",
  position = "0x0", -- not auto-left: negative origin breaks ueberzugpp image placement
  scale = 2,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "highres",
  position = "auto-right",
  scale = 1,
  -- mirror = "eDP-1"
})
