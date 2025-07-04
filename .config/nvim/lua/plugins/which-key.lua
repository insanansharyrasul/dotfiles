-- Which-key keybinding hints configuration
local wk_ok, wk = pcall(require, 'which-key')
if not wk_ok then
  return
end

wk.setup({
  preset = "modern",
  delay = 200,
})

-- New which-key spec format - resolves overlapping keys by grouping
wk.add({
  -- Core navigation and actions
  { "<leader>a", "<C-o>", desc = "Navigate Back" },
  { "<leader>q", function() vim.lsp.buf.format { async = true } end, desc = "Format Document" },
  
  -- File operations group
  { "<leader>f", group = "File" },
  { "<leader>ff", ":Telescope find_files<CR>", desc = "Find Files" },
  { "<leader>fg", ":Telescope live_grep<CR>", desc = "Live Grep" },
  { "<leader>fb", ":Telescope buffers<CR>", desc = "Buffers" },
  { "<leader>fh", ":Telescope help_tags<CR>", desc = "Help Tags" },
  
  -- Window/Split operations
  { "<leader>w", group = "Window" },
  { "<leader>wv", ":vsplit<CR>", desc = "Vertical Split" },
  { "<leader>ws", ":split<CR>", desc = "Horizontal Split" },
  { "<leader>wh", "<C-w>h", desc = "Focus Left Pane" },
  { "<leader>wj", "<C-w>j", desc = "Focus Below Pane" },
  { "<leader>wk", "<C-w>k", desc = "Focus Above Pane" },
  { "<leader>wl", "<C-w>l", desc = "Focus Right Pane" },
  { "<leader>wc", ":bd<CR>", desc = "Close Buffer" },
  { "<leader>wb", ":!flutter build<CR>", desc = "Build Task" },
  
  -- Debug operations group
  { "<leader>d", group = "Debug" },
  { "<leader>dr", ":FlutterRun<CR>", desc = "Run/Start Debug" },
  { "<leader>dt", ":FlutterQuit<CR>", desc = "Stop Debug" },
  { "<leader>de", ":FlutterReload<CR>", desc = "Continue/Hot Reload" },
  { "<leader>dd", ":FlutterRestart<CR>", desc = "Restart Debug" },
  { "<leader>db", function() vim.lsp.buf.code_action() end, desc = "Toggle Breakpoint/Code Action" },
  
  -- LSP operations group
  { "<leader>c", group = "Code" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
  { "<leader>cd", vim.diagnostic.open_float, desc = "Show Diagnostics" },
  { "<leader>cf", function() vim.lsp.buf.format { async = true } end, desc = "Format Document" },
  
  -- Flutter specific group
  { "<leader>F", group = "Flutter" },
  { "<leader>Fr", ":FlutterRun<CR>", desc = "Flutter Run" },
  { "<leader>Fq", ":FlutterQuit<CR>", desc = "Flutter Quit" },
  { "<leader>Fh", ":FlutterReload<CR>", desc = "Flutter Hot Reload" },
  { "<leader>FR", ":FlutterRestart<CR>", desc = "Flutter Hot Restart" },
  { "<leader>Fd", ":FlutterDevices<CR>", desc = "Flutter Devices" },
  { "<leader>Fe", ":FlutterEmulators<CR>", desc = "Flutter Emulators" },
  { "<leader>Fo", ":FlutterOutlineToggle<CR>", desc = "Toggle Outline" },
  
  -- Rust development group
  { "<leader>r", group = "Rust" },
  { "<leader>rr", ":!cargo run<CR>", desc = "Cargo Run" },
  { "<leader>rt", ":!cargo test<CR>", desc = "Cargo Test" },
  { "<leader>rb", ":!cargo build<CR>", desc = "Cargo Build" },
  { "<leader>rc", ":!cargo check<CR>", desc = "Cargo Check" },
  { "<leader>rC", ":!cargo clippy<CR>", desc = "Cargo Clippy" },
  { "<leader>rf", ":!cargo fmt<CR>", desc = "Cargo Format" },
  { "<leader>rd", ":!cargo doc --open<CR>", desc = "Cargo Docs" },
  
  -- Crates.nvim group
  { "<leader>c", group = "Code/Crates" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
  { "<leader>cd", vim.diagnostic.open_float, desc = "Show Diagnostics" },
  { "<leader>cf", function() vim.lsp.buf.format { async = true } end, desc = "Format Document" },
  { "<leader>ct", desc = "Toggle Crates" },
  { "<leader>cu", desc = "Update Crate" },
  { "<leader>cU", desc = "Upgrade Crate" },
  { "<leader>ca", desc = "Update All Crates" },
  { "<leader>cA", desc = "Upgrade All Crates" },
  { "<leader>cH", desc = "Open Homepage" },
  { "<leader>cR", desc = "Open Repository" },
  { "<leader>cD", desc = "Open Documentation" },
  { "<leader>cC", desc = "Open Crates.io" },
  
  -- Keep some original mappings for muscle memory
  { "<leader>v", ":vsplit<CR>", desc = "Vertical Split" },
  { "<leader>s", ":split<CR>", desc = "Horizontal Split" },
  { "<leader>h", "<C-w>h", desc = "Focus Left Pane" },
  { "<leader>j", "<C-w>j", desc = "Focus Below Pane" },
  { "<leader>k", "<C-w>k", desc = "Focus Above Pane" },
  { "<leader>l", "<C-w>l", desc = "Focus Right Pane" },
})
