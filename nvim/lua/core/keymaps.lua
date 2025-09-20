-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- ========================================
-- Arrow Key Movement (Primary Navigation)
-- ========================================
vim.keymap.set({ 'n', 'v' }, '<Up>', 'k', opts) -- Up
vim.keymap.set({ 'n', 'v' }, '<Down>', 'j', opts) -- Down
vim.keymap.set({ 'n', 'v' }, '<Left>', 'h', opts) -- Left
vim.keymap.set({ 'n', 'v' }, '<Right>', 'l', opts) -- Right

-- ========================================
-- Window Resizing with HJKL
-- ========================================
vim.keymap.set('n', 'h', ':vertical resize -2<CR>', opts) -- narrower
vim.keymap.set('n', 'j', ':resize +2<CR>', opts) -- taller
vim.keymap.set('n', 'k', ':resize -2<CR>', opts) -- shorter
vim.keymap.set('n', 'l', ':vertical resize +2<CR>', opts) -- wider

-- ========================================
-- File Operations
-- ========================================
vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', opts) -- save file
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w<CR>', opts) -- save without formatting
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', opts) -- quit file
vim.keymap.set('n', 'x', '"_x', opts) -- delete without copying

-- ========================================
-- Enhanced Navigation
-- ========================================
-- Scrolling with centering
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts) -- half page down
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts) -- half page up

-- Search navigation
vim.keymap.set('n', 'n', 'nzzzv', opts) -- next match centered
vim.keymap.set('n', 'N', 'Nzzzv', opts) -- prev match centered

-- ========================================
-- Window Management
-- ========================================
-- Splits
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- vertical split
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- horizontal split
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- equalize splits
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close split

-- Window navigation (using arrow keys)
vim.keymap.set('n', '<C-Up>', ':wincmd k<CR>', opts) -- up window
vim.keymap.set('n', '<C-Down>', ':wincmd j<CR>', opts) -- down window
vim.keymap.set('n', '<C-Left>', ':wincmd h<CR>', opts) -- left window
vim.keymap.set('n', '<C-Right>', ':wincmd l<CR>', opts) -- right window

-- ========================================
-- Buffer Management
-- ========================================
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts) -- next buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts) -- prev buffer
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', opts) -- new buffer

-- ========================================
-- Tab Management
-- ========================================
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) -- next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) -- prev tab

-- ========================================
-- Other Utilities
-- ========================================
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts) -- toggle wrap
vim.keymap.set('v', '<', '<gv', opts) -- maintain selection after indent
vim.keymap.set('v', '>', '>gv', opts) -- maintain selection after outdent
vim.keymap.set('v', 'p', '"_dP', opts) -- paste without overwriting register

-- ========================================
-- Toggleterminal
-- ========================================
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<cr>', { noremap = true, silent = true })

-- ========================================
-- Platformio
-- ========================================
vim.keymap.set('n', '<leader>pi', ':Pioinit<CR>', opts) -- Initialize PlatformIO project_file
vim.keymap.set('n', '<leader>pm', ':Piomon<CR>', opts) -- Monitor board output
vim.keymap.set('n', '<leader>pb', ':Piorun build<CR>', opts) -- Build PlatformIO project
vim.keymap.set('n', '<leader>pu', ':Piorun<CR>', opts) -- Upload program to device
vim.keymap.set('n', '<leader>pd', ':Piodb<CR>', opts) -- Debugger tool

-- ========================================
-- Code Runner
-- ========================================
vim.keymap.set('n', '<leader>rr', ':RunCode<CR>', opts) -- Run code in current buffer
vim.keymap.set('n', '<leader>rc', ':RunClose<CR>', opts) -- Close code runner output
vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', opts) -- Run current file

-- ========================================
-- Tagbar
-- ========================================
vim.keymap.set('n', '<leader><F6>', ':TagbarToggle<CR>', opts) -- Toggle Tagbar

-- ========================================
-- Undotree
-- ========================================
vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle) -- Toggle Undotree

-- ========================================
-- CMake
-- =======================================
vim.keymap.set('n', '<leader>cb', ':CMakeBuild<CR>', opts) -- Open CMake menu

-- ========================================
-- Diagnostics
-- ========================================
vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
