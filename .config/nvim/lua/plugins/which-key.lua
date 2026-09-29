return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup({ preset = "modern", delay = 200 })
    wk.add({
      { "<leader>a", "<C-o>", desc = "Navigate Back" },
      { "<leader>q", function() vim.lsp.buf.format({ async = true }) end, desc = "Format Document" },
      { "<leader>as", ":ASToggle<CR>", desc = "Toggle Auto-save" },
      { "<leader>f", group = "File" },
      { "<leader>ff", ":Telescope find_files<CR>", desc = "Find Files" },
      { "<leader>fg", ":Telescope live_grep<CR>", desc = "Live Grep" },
      { "<leader>fb", ":Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", ":Telescope help_tags<CR>", desc = "Help Tags" },
      { "<leader>w", group = "Window" },
      { "<leader>wv", ":vsplit<CR>", desc = "Vertical Split" },
      { "<leader>ws", ":split<CR>", desc = "Horizontal Split" },
      { "<leader>wh", "<C-w>h", desc = "Focus Left Pane" },
      { "<leader>wj", "<C-w>j", desc = "Focus Below Pane" },
      { "<leader>wk", "<C-w>k", desc = "Focus Above Pane" },
      { "<leader>wl", "<C-w>l", desc = "Focus Right Pane" },
      { "<leader>wc", ":bd<CR>", desc = "Close Buffer" },
      { "<leader>d", group = "Debug" },
      { "<leader>db", vim.lsp.buf.code_action, desc = "Code Action" },
      { "<leader>c", group = "Code" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>cd", vim.diagnostic.open_float, desc = "Show Diagnostics" },
      { "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format Document" },
      { "<leader>v", ":vsplit<CR>", desc = "Vertical Split" },
      { "<leader>s", ":split<CR>", desc = "Horizontal Split" },
      { "<leader>h", "<C-w>h", desc = "Focus Left Pane" },
      { "<leader>j", "<C-w>j", desc = "Focus Below Pane" },
      { "<leader>k", "<C-w>k", desc = "Focus Above Pane" },
      { "<leader>l", "<C-w>l", desc = "Focus Right Pane" },
    })
  end,
}
