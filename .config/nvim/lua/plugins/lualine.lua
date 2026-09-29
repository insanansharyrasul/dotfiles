return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = {
          normal = {
            a = { fg = "#0b0e14", bg = "#36A3D9", gui = "bold" },
            b = { fg = "#BFBDB6", bg = "#1F2430" },
            c = { fg = "#BFBDB6", bg = "#0F1419" },
          },
          insert = { a = { fg = "#0b0e14", bg = "#B8CC52", gui = "bold" } },
          visual = { a = { fg = "#0b0e14", bg = "#F07178", gui = "bold" } },
          replace = { a = { fg = "#0b0e14", bg = "#FF8F40", gui = "bold" } },
          inactive = {
            a = { fg = "#828C99", bg = "#0b0e14" },
            b = { fg = "#828C99", bg = "#0b0e14" },
            c = { fg = "#828C99", bg = "#0b0e14" },
          },
        },
        icons_enabled = true,
      },
    })
  end,
}
