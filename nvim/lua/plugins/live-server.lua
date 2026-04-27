return {
    'barrett-ruth/live-server.nvim',
    lazy = true,
    build = 'pnpm add -g live-server',
    ft = 'html',
    -- cmd = { 'LiveServerStart', 'LiveServerStop' },
    config = true,
    keys = {
        {
            '<leader>ls',
            '<cmd>LiveServerStart<cr>',
            desc = 'Start Live Server',
        },
        {
            '<leader>lx',
            '<cmd>LiveServerStop<cr>',
            desc = 'Stop Live Server',
        },
    },
}
