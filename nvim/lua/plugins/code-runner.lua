return {
    'CRAG666/code_runner.nvim',
    config = function()
        require('code_runner').setup {
            filetype = {
                python = function()
                    local venv = vim.g.VIRTUAL_ENV
                    if venv and venv ~= '' then
                        return string.format('source %s/bin/activate && python3 %s', venv, vim.fn.expand '%')
                    else
                        return 'python3 ' .. vim.fn.expand '%'
                    end
                end,
                -- Add other filetypes as needed
            },
            -- Other code_runner options...
        }
    end,
}
