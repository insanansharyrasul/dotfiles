return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader>ff", ":Telescope find_files<CR>", desc = "Find Files", silent = true },
    { "<leader>fg", ":Telescope live_grep<CR>", desc = "Live Grep", silent = true },
    { "<leader>fb", ":Telescope buffers<CR>", desc = "Buffers", silent = true },
    { "<leader>fh", ":Telescope help_tags<CR>", desc = "Help Tags", silent = true },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = { mappings = { i = { ["<C-h>"] = "which_key" } } },
    })
  end,
}
