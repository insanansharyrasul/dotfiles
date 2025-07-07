local keymap = vim.keymap.set

-- Basic remaps
keymap('n', '<C-z>', 'u', { noremap = true, silent = true })
keymap('v', '<C-S-c>', '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
keymap('n', '<C-S-c>', '"+yy', { noremap = true, silent = true, desc = "Copy line to clipboard" })

-- VSCode-like navigation mappings
-- Buffer navigation
keymap('n', '<S-h>', ':bprevious<CR>', { noremap = true, silent = true })
keymap('n', '<S-l>', ':bnext<CR>', { noremap = true, silent = true })

-- Split creation
keymap('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })
keymap('n', '<leader>s', ':split<CR>', { noremap = true, silent = true })

-- Navigate back
keymap('n', '<leader>a', '<C-o>', { noremap = true, silent = true })

-- Pane navigation
keymap('n', '<leader>h', '<C-w>h', { noremap = true, silent = true })
keymap('n', '<leader>j', '<C-w>j', { noremap = true, silent = true })
keymap('n', '<leader>k', '<C-w>k', { noremap = true, silent = true })
keymap('n', '<leader>ll', '<C-w>l', { noremap = true, silent = true })

-- Clear search highlighting
keymap('n', '<C-n>', ':nohl<CR>', { noremap = true, silent = true })

-- Visual mode improvements
keymap('v', '<', '<gv', { noremap = true, silent = true })
keymap('v', '>', '>gv', { noremap = true, silent = true })

-- Move selected lines up/down in visual mode
keymap('v', 'J', ":move '>+1<CR>gv=gv", { noremap = true, silent = true })
keymap('v', 'K', ":move '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Debug/Build mappings (Flutter)
keymap('n', '<leader>r', ':FlutterRun<CR>', { noremap = true, silent = true, desc = "Run/Debug" })
keymap('n', '<leader>t', ':FlutterQuit<CR>', { noremap = true, silent = true, desc = "Stop Debug" })
keymap('n', '<leader>er', ':FlutterReload<CR>', { noremap = true, silent = true, desc = "Continue/Hot Reload" })
keymap('n', '<leader>d', ':FlutterRestart<CR>', { noremap = true, silent = true, desc = "Restart Debug" })
keymap('n', '<leader>b', function() vim.lsp.buf.code_action() end, { noremap = true, silent = true, desc = "Toggle Breakpoint/Code Action" })
keymap('n', '<leader>w', ':!flutter build<CR>', { noremap = true, silent = true, desc = "Build Task" })

-- Comment toggle
keymap('v', '<leader>c', 'gc', { noremap = false, silent = true })
keymap('n', '<leader>c', 'gcc', { noremap = false, silent = true })

-- Additional VSCode-like keybindings
keymap('n', '<leader>ee', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle File Explorer" }) 
keymap('n', '<C-q>', ':bd<CR>', { noremap = true, silent = true, desc = "Close Buffer" }) 
keymap('n', '<C-j>', '<C-w>w', { noremap = true, silent = true, desc = "Focus next window" })
keymap('n', '<C-S-j>', ':terminal<CR>', { noremap = true, silent = true, desc = "Toggle Terminal" })
keymap('n', '<A-j>', ':move .+1<CR>==', { noremap = true, silent = true, desc = "Move line down" })
keymap('n', '<A-k>', ':move .-2<CR>==', { noremap = true, silent = true, desc = "Move line up" })
keymap('v', '<A-j>', ":move '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
keymap('v', '<A-k>', ":move '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })
keymap('n', '<C-S-k>', '<C-v>k', { noremap = true, silent = true, desc = "Add cursor above" })
keymap('n', '<C-S-v>', '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })
keymap('t', '<C-l><C-k>', '<C-\\><C-n>:clear<CR>i', { noremap = true, silent = true, desc = "Clear terminal" })

-- Keep some quick access mappings for muscle memory while also having grouped versions
keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true, desc = "Find Files" }) 

-- Keymaps for LSP and diagnostics
keymap("n", "<leader>le", vim.diagnostic.open_float, { desc = "Show Line Diagnostics" })
