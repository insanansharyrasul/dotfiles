-- Basic Vim Setup
local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.timeoutlen = 1000
opt.ttimeoutlen = 0
opt.expandtab = true
opt.shiftwidth = 4
opt.incsearch = true
opt.hlsearch = true

-- Set leader key
vim.g.mapleader = " "

-- Hide end-of-buffer lines
vim.api.nvim_set_hl(0, 'NonText', { fg = 'bg' })
