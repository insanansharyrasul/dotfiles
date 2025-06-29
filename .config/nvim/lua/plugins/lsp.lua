-- LSP Configuration
local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_ok then
  vim.notify("LSP config not available. Run :PlugInstall to install plugins.", vim.log.levels.WARN)
  return
end

-- LSP keybindings
local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  
  -- Navigation
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  
  -- VSCode-style mappings
  vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts) -- matches your g,h
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts) -- matches your leader,c,a
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>q', function() vim.lsp.buf.format { async = true } end, bufopts) -- matches your leader,q
  vim.keymap.set('n', '<leader>f', ':Telescope find_files<CR>', bufopts) -- matches your leader,f for quickOpen
  
  -- Diagnostics (matching your [d and ]d)
  vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '<leader>ld', vim.diagnostic.setloclist, bufopts)
end

-- Dart/Flutter LSP setup
lspconfig.dartls.setup({
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  settings = {
    dart = {
      completeFunctionCalls = true,
      showTodos = true,
    }
  }
})
