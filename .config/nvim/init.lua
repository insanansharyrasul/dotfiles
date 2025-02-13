-- Basic Vim Setup
vim.opt.relativenumber = true
vim.opt.nu = true
vim.api.nvim_set_hl(0, 'NonText', { fg = 'bg' })
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.g.mapleader = " "

-- Plugins
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('m4xshen/autoclose.nvim')
Plug('https://tpope.io/vim/surround.git')
Plug('https://github.com/Shatur/neovim-ayu.git')

vim.call('plug#end')

require("autoclose").setup()

require('ayu').setup({
    mirage = false,
    terminal = true,
    overrides = {},
})

require('ayu').colorscheme()
