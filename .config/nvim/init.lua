if vim.islist and not vim.tbl_islist then
  vim.tbl_islist = vim.islist
end
-- Modular Neovim Configuration (lazy.nvim)
require('config.options') -- Basic Vim options
require('config.keymaps') -- Key mappings
require('config.lazy')    -- Plugin manager bootstrap
