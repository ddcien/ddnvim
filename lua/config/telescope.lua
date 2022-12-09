return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.x',
    requires = {
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
        },
        {
            'jvgrootveld/telescope-zoxide',
        },
        {
            'nvim-telescope/telescope-cheat.nvim',
            requires = { "kkharji/sqlite.lua" }
        },

        {
            "nvim-telescope/telescope-frecency.nvim",
            requires = { "kkharji/sqlite.lua" }
        },
    },
    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')
        local builtin = require('telescope.builtin')

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            }
        })

        telescope.load_extension('fzf')
        telescope.load_extension('zoxide')
        telescope.load_extension('cheat')
        telescope.load_extension('frecency')
        telescope.load_extension('lazygit')

        vim.api.nvim_create_user_command(
            "Rg",
            function(args)
                if string.len(args.args) == 0 then
                    builtin.grep_string()
                else
                    builtin.grep_string({ search = args.args })
                end
            end,
            { nargs = "?" }
        )
    end
}
