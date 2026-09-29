return {
  "Pocco81/auto-save.nvim",
  event = "VeryLazy",
  config = function()
    local autosave = require("auto-save")
    autosave.setup({
      enabled = true,
      execution_message = {
        message = function()
          return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
        end,
        dim = 0.18,
        cleaning_interval = 1250,
      },
      trigger_events = { "InsertLeave" },
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")
        local time_since_insert = vim.fn.reltimestr(vim.fn.reltime(vim.g.last_insert_enter or vim.fn.reltime()))
        if tonumber(time_since_insert) < 0.5 then
          return false
        end
        local excluded_filetypes = {
          "oil", "NvimTree", "neo-tree", "alpha", "dashboard",
          "TelescopePrompt", "prompt", "gitcommit", "help",
          "nofile", "terminal", "dapui_watches", "dapui_stacks",
          "dapui_breakpoints", "dapui_scopes", "dapui_console", "dap-repl",
        }
        if vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype) then
          return false
        end
        if vim.bo[buf].filetype == "sql" then
          return false
        end
        if
          fn.getbufvar(buf, "&modifiable") == 1
          and fn.empty(fn.bufname(buf)) == 0
          and utils.not_in(fn.getbufvar(buf, "&buftype"), { "terminal", "nofile" })
        then
          return true
        end
        return false
      end,
      write_all_buffers = false,
      debounce_delay = 2000,
    })
    vim.keymap.set("n", "<leader>as", ":ASToggle<CR>", { desc = "Toggle Auto-save", silent = true })
    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function() vim.g.last_insert_enter = vim.fn.reltime() end,
    })
  end,
}
