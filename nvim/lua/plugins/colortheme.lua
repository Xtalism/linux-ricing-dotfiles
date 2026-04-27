return {
    {
        'sainnhe/gruvbox-material',
        name = 'gruvbox-material-hard',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_foreground = 'material'
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_disable_italic_comment = 0
            vim.g.gruvbox_material_better_performance = 1
            vim.cmd 'colorscheme gruvbox-material'
        end,
    },
    {
        'sainnhe/everforest',
        name = 'everforest',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.everforest_background = 'hard'
            vim.cmd 'colorscheme everforest'
        end,
    },
    {
        'ribru17/bamboo.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('bamboo').setup {
                style = 'multiplex',
            }
            require('bamboo').load()
        end,
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd 'colorscheme rose-pine'

            require('rose-pine').setup {
                variant = 'auto', -- auto, main, moon, or dawn
                dark_variant = 'main', -- main, moon, or dawn
                dim_inactive_windows = false,
                extend_background_behind_borders = true,

                enable = {
                    terminal = true,
                    legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                    migrations = true, -- Handle deprecated options automatically
                },

                styles = {
                    bold = true,
                    italic = true,
                    transparency = false,
                },
            }
        end,
    },
}
