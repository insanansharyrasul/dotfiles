-- Modular Neovim Configuration
-- Load configuration modules
require('config.options')      -- Basic Vim options
require('config.keymaps')      -- Key mappings
require('config.plugins')      -- Plugin management
require('config.colorscheme')  -- Color scheme setup
require('config.flutter')     -- Flutter-specific settings
require('config.rust')        -- Rust development setup

-- Load plugin configurations
require('plugins.autoclose')
require('plugins.lualine')
require('plugins.completion')
require('plugins.lsp')
require('plugins.treesitter')
require('plugins.nvim-tree')
require('plugins.telescope')
require('plugins.which-key')
require('plugins.gitsigns')
require('plugins.auto-save')
