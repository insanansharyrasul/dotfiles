return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  keys = {
    { "<leader>ee", ":NvimTreeToggle<CR>", desc = "Toggle File Explorer", silent = true },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local api = require("nvim-tree.api")
    local function my_on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end
      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.set("n", "l", function()
        if api.tree.get_node_under_cursor() then api.node.open.edit() end
      end, opts("Open"))
      vim.keymap.set("n", "h", function()
        if api.tree.get_node_under_cursor() then api.node.navigate.parent_close() end
      end, opts("Close Directory"))
      vim.keymap.set("n", "v", function()
        if api.tree.get_node_under_cursor() then api.node.open.vertical() end
      end, opts("Open: Vertical Split"))
    end
    require("nvim-tree").setup({
      on_attach = my_on_attach,
      view = { width = 30, side = "right" },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
    })
  end,
}
