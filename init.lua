require('vars')
require('opts')
require('keys')
require('plug')

vim.cmd.colorscheme "catppuccin"

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({higroup="IncSearch", timeout=200})
    end
})

--// au TextYankPost * silent! lua 
