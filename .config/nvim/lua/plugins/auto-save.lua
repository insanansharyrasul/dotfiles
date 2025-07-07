-- Auto-save configuration
local autosave_ok, autosave = pcall(require, "auto-save")
if not autosave_ok then
  vim.notify("auto-save.nvim not found. Run :PlugInstall to install plugins.", vim.log.levels.WARN)
  return
end

autosave.setup({
  enabled = true, -- start auto-save when the plugin is loaded
  execution_message = {
    message = function() -- message to print on save
      return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
    end,
    dim = 0.18, -- dim the color of `message`
    cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`
  },
  trigger_events = {"InsertLeave"}, -- auto-save when leaving insert mode or losing focus
  -- function that determines whether to save the current file or not
  condition = function(buf)
    local fn = vim.fn
    local utils = require("auto-save.utils.data")

    -- don't save if we're in the middle of typing (check if we just entered insert mode)
    local time_since_insert = vim.fn.reltimestr(vim.fn.reltime(vim.g.last_insert_enter or vim.fn.reltime()))
    if tonumber(time_since_insert) < 0.5 then -- less than 500ms since entering insert mode
      return false
    end

    -- don't save for certain file types
    local excluded_filetypes = {
      "oil",
      "NvimTree",
      "neo-tree",
      "alpha",
      "dashboard",
      "TelescopePrompt",
      "prompt",
      "gitcommit",
      "help",
      "nofile",
      "terminal",
      "dapui_watches",
      "dapui_stacks",
      "dapui_breakpoints",
      "dapui_scopes",
      "dapui_console",
      "dap-repl"
    }

    if vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype) then
      return false
    end

    -- don't save for `sql` file types
    if vim.bo[buf].filetype == "sql" then
      return false
    end

    -- only save if file is modifiable and has a name
    if
      fn.getbufvar(buf, "&modifiable") == 1 and
      fn.empty(fn.bufname(buf)) == 0 and
      utils.not_in(fn.getbufvar(buf, "&buftype"), {"terminal", "nofile"})
    then
      return true -- met condition(s), can save
    end
    return false -- can't save
  end,
  write_all_buffers = false, -- write all buffers when the current one meets `condition`
  debounce_delay = 2000, -- increased delay - saves the file at most every 2 seconds
  callbacks = { -- functions to be executed at different intervals
    enabling = nil, -- ran when enabling auto-save
    disabling = nil, -- ran when disabling auto-save
    before_asserting_save = nil, -- ran before checking `condition`
    before_saving = nil, -- ran before doing the actual save
    after_saving = nil -- ran after doing the actual save
  }
})

-- Add toggle keybinding for auto-save
vim.keymap.set("n", "<leader>as", ":ASToggle<CR>", { desc = "Toggle Auto-save", silent = true })

-- Track when we enter insert mode to prevent immediate saves
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.g.last_insert_enter = vim.fn.reltime()
  end,
})
