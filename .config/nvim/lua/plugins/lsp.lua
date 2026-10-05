return {
  "neovim/nvim-lspconfig",
  ft = { "c", "cpp" },
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    -- ponytail: show clangd E/W inline, no new plugin needed
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = { border = "rounded", source = "always" },
    })

    local on_attach = function(_, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
      vim.keymap.set("n", "gh", vim.lsp.buf.hover, bufopts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
      vim.keymap.set("n", "<leader>q", function() vim.lsp.buf.format({ async = true }) end, bufopts)
      vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>", bufopts)
      vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, bufopts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
      vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist, bufopts)
    end

    vim.lsp.config("clangd", {
      on_attach = on_attach,
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--tweaks=-std=c++23"
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    })
    vim.lsp.enable("clangd")
  end,
}
