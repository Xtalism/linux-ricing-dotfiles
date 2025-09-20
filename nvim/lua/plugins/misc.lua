-- Standalone plugins with less than 10 lines of config go here
return {
    {
        'Civitasv/cmake-tools.nvim',
        opts = {
            prefix_name = 'cmake',
            cmake_terminal = 'toggleterm',
        },
    },
    {
        '3rd/image.nvim',
        build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
        opts = {
            processor = 'magick_cli',
            backend = 'kitty',
        },
    },
    {
        'mbbill/undotree',
    },
    {
        'preservim/tagbar',
    },
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        opts = {
            shell = 'bash',
            direction = 'float',
            open_mapping = [[<c-\>]],
            on_open = function(term)
                vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<esc>', '<cmd>close<CR>', { noremap = true, silent = true })
            end,
        },
    },
    {
        'tpope/vim-surround',
    },
    {
        'lervag/vimtex',
        lazy = false, -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = 'zathura'
        end,
    },
    {
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        build = 'cd app && npm install',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        ft = { 'markdown' },
    },
    {
        'numToStr/Comment.nvim',
        opts = {},
    },
    {
        'mg979/vim-visual-multi',
        keys = {
            { '<C-n>', mode = 'n', '<Plug>(VM-Find-Under' },
        },
    },
    {
        -- Tmux & split window navigation
        'christoomey/vim-tmux-navigator',
    },
    {
        -- Detect tabstop and shiftwidth automatically
        'tpope/vim-sleuth',
    },
    {
        -- Powerful Git integration for Vim
        'tpope/vim-fugitive',
    },
    {
        -- GitHub integration for vim-fugitive
        'tpope/vim-rhubarb',
    },
    {
        -- Hints keybinds
        'folke/which-key.nvim',
    },
    {
        -- Autoclose parentheses, brackets, quotes, etc.
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = true,
        opts = {},
    },
    {
        -- Highlight todo, notes, etc in comments
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false },
    },
    {
        -- High-performance color highlighter
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    },
}
