return {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/playground',
        'p00f/nvim-ts-rainbow',
    },
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = "all",
            sync_install = false,
            auto_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },
            rainbow = {
                enable = true,
                extended_mode = true,
            },
            playground = {
                 enable = true,
            }
        })
    end,
}
