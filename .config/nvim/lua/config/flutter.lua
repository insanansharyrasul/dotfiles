-- Flutter-specific autocmds and settings
-- Auto commands for Flutter
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.dart",
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- Additional Flutter settings
vim.g.dart_style_guide = 2
vim.g.dart_format_on_save = 1
