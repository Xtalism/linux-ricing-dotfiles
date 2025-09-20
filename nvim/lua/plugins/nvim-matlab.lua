function KillMatlabWindows()
    local rg_output = vim.fn.system 'tasklist /fo table | rg MATLAB | findstr MATLAB.exe'
    local pid = rg_output:match 'MATLAB%.exe%s+(%d+)'
    if pid then
        vim.fn.system('taskkill /F /PID ' .. pid)
        vim.cmd 'RunClose'
        print('Killed MATLAB.exe with PID: ' .. pid)
    else
        print 'No MATLAB.exe process found.'
    end
end

function RestartMatlabIfExists()
    -- Check for running MATLAB process
    local output = vim.fn.system 'tasklist /fo table | findstr MATLAB.exe'
    local pid = output:match 'MATLAB%.exe%s+(%d+)'
    if pid then
        vim.fn.system('taskkill /F /PID ' .. pid)
        print('Killed MATLAB.exe with PID: ' .. pid)
    else
        print 'MATLAB.exe is not running, starting a new one.'
    end
    -- Always start a new MATLAB process for current buffer
    local fullpath = vim.fn.expand '%:p'
    local cmd = string.format('matlab -automation -r "run %s"', fullpath)
    vim.fn.jobstart(cmd)
    print('Started new MATLAB process for: ' .. fullpath)
end

function SimulinkStartup()
    local fullpath = vim.fn.expand '%:p'
    local cmd = string.format 'matlab -automation -r simulink'
    vim.fn.jobstart(cmd)
    print('Started new Simulink process for: ' .. fullpath)
end

function AppDesignerStartup()
    local fullpath = vim.fn.expand '%:p'
    local cmd = string.format 'matlab -automation -r appdesigner'
    vim.fn.jobstart(cmd)
    print('Started new App Designer process for: ' .. fullpath)
end

vim.api.nvim_set_keymap('n', '<leader>rm', '', {
    noremap = true,
    callback = RestartMatlabIfExists,
    desc = 'Restart MATLAB (kill old and run buffer)',
})

vim.api.nvim_set_keymap('n', '<leader>km', '', {
    noremap = true,
    callback = KillMatlabWindows,
    desc = 'Kill MATLAB process on Windows',
})

vim.api.nvim_set_keymap('n', '<leader>rs', '', {
    noremap = true,
    callback = SimulinkStartup,
    desc = 'Start Simulink',
})

vim.api.nvim_set_keymap('n', '<leader>ra', '', {
    noremap = true,
    callback = AppDesignerStartup,
    desc = 'Start App Designer',
})
