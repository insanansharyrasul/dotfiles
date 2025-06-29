-- Telescope fuzzy finder configuration
local telescope_ok, telescope = pcall(require, 'telescope')
if not telescope_ok then
  return
end

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    }
  }
})
