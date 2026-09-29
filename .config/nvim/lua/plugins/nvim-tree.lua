return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  keys = {
    { "<leader>ee", ":NvimTreeToggle<CR>", desc = "Toggle File Explorer", silent = true },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local api = require("nvim-tree.api")
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, noremap = true, silent = true, nowait = true }
    end
    local function my_on_attach(bufnr)
      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
      vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
      vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
    end
    require("nvim-tree").setup({
      on_attach = my_on_attach,
      view = { width = 30, side = "right" },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
    })
  end,
}
