-- Plugin Management with vim-plug
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Core plugins
Plug('m4xshen/autoclose.nvim')
Plug('https://tpope.io/vim/surround.git')
Plug('https://tpope.io/vim/commentary.git')  -- For comment toggling
Plug('https://github.com/Shatur/neovim-ayu.git')

-- LSP and completion
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('L3MON4D3/LuaSnip')
Plug('saadparwaiz1/cmp_luasnip')

-- Flutter/Dart specific
Plug('dart-lang/dart-vim-plugin')
Plug('thosakwe/vim-flutter')
Plug('nvim-lua/plenary.nvim')
Plug('stevearc/dressing.nvim')

-- File explorer and fuzzy finder
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.4' })

-- Git integration
Plug('lewis6991/gitsigns.nvim')

-- Status line
Plug('nvim-lualine/lualine.nvim')

-- Treesitter for better syntax highlighting
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

-- Rust development
Plug('rust-lang/rust.vim')
Plug('simrat39/rust-tools.nvim')
Plug('saecki/crates.nvim')

-- DAP (Debug Adapter Protocol) for debugging
Plug('mfussenegger/nvim-dap')
Plug('nvim-neotest/nvim-nio')  -- Required dependency for nvim-dap-ui
Plug('rcarriga/nvim-dap-ui')
Plug('theHamsta/nvim-dap-virtual-text')

-- Which-key for keybinding hints
Plug('folke/which-key.nvim')

vim.call('plug#end')
