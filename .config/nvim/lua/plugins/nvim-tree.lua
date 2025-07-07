-- Nvim-tree file explorer configuration
local nvim_tree_ok, nvim_tree = pcall(require, 'nvim-tree')
if not nvim_tree_ok then
  return
end

local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Remove nvim-tree's default <C-e> mapping and set close functionality
  -- vim.keymap.set('n', '<C-e>', api.tree.close, opts('Close Tree'))

  -- Default mappings
  api.config.mappings.default_on_attach(bufnr)
  
  -- VSCode-like keybindings
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
end

nvim_tree.setup({
  on_attach = my_on_attach,
  view = {
    width = 30,
    side = "right"
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})
