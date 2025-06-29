-- Autoclose plugin setup
local autoclose_ok, autoclose = pcall(require, "autoclose")
if autoclose_ok then
  autoclose.setup()
end
