local function ensure_packer()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup({ function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-tree/nvim-web-devicons'

    use(require("config.treesitter"))
    use(require("config.telescope"))

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'

    use(require("config.lspconfig"))
    use {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black,
                    -- null_ls.builtins.completion.spell,
                },
            })
        end
    }
    use 'kdheepak/lazygit.nvim'

    use {
        '/work/ddcien/nvim-cmp',
        requires = {
            'onsails/lspkind.nvim'
        },
        config = function() require('config.cmp') end
    }

    use {
        'nvim-lualine/lualine.nvim',
        config = function() require("lualine").setup() end,
    }
    use {
        'stevearc/dressing.nvim',
        config = function() require('dressing').setup({}) end
    }

    use {
        'nvim-tree/nvim-tree.lua',
        tag = 'nightly',
        config = function()
            require("nvim-tree").setup({
                remove_keymaps = { "<C-e>" }
            })
            vim.api.nvim_set_keymap(
                'n',
                '<C-e>',
                "<cmd>NvimTreeToggle<cr>",
                { noremap = true, silent = true }
            )
        end,
    }

    use {
        "folke/which-key.nvim",
        config = function() require("which-key").setup() end,
    }
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map('n', ']c',
                        function()
                            if vim.wo.diff then return ']c' end
                            vim.schedule(function() gs.next_hunk() end)
                            return '<Ignore>'
                        end,
                        { expr = true })

                    map('n', '[c',
                        function()
                            if vim.wo.diff then
                                return '[c'
                            end
                            vim.schedule(function() gs.prev_hunk() end)
                            return '<Ignore>'
                        end,
                        { expr = true })

                    -- Actions
                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end
            })
        end
    }
    use { "akinsho/toggleterm.nvim",
        disable = true,
        tag = '*',
        config = function() require("toggleterm").setup() end
    }

    use '/work/ddcien/lsp-semantic.nvim'
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                show_current_context = true,
                show_current_context_start = true,
            })
        end
    }

    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {
            }
        end
    }

    use {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
            })
        end
    }
    use {
        "catppuccin/nvim", as = "catppuccin",
    }

    use {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end
    }

    use {
        'simrat39/symbols-outline.nvim',
        config = function() require("symbols-outline").setup() end
    }

    use 'rcarriga/nvim-notify'


    use {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup {
                sources = {
                    ['null-ls'] = { ignore = true },
                },
            }
        end,
    }

    use {
        'ethanholz/nvim-lastplace',
        config = function() require('nvim-lastplace').setup {} end,
    }

    use {
        'andymass/vim-matchup',
        setup = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end,
    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end
        }
    }
})
