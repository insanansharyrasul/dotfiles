-- Treesitter configuration
local treesitter_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not treesitter_ok then
  return
end

treesitter.setup {
  ensure_installed = { "dart", "lua", "vim", "javascript", "typescript", "json", "yaml" },
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
