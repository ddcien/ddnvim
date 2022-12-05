return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-tree/nvim-web-devicons'

    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function() require('config.treesitter') end
    }

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use {
        'neovim/nvim-lspconfig',
        config = function() require('config.lspconfig') end
    }
    use {
        'hrsh7th/nvim-cmp',
        config = function() require('config.cmp') end
    }

    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
    }
    use {
        'nvim-lualine/lualine.nvim',
        config = function() require("lualine").setup() end,
    }
    use {
        'nvim-tree/nvim-tree.lua',
        tag = 'nightly',
        config = function() require("nvim-tree").setup() end,
    }
    use {
        "folke/which-key.nvim",
        config = function() require("which-key").setup() end,
    }
    use {
        'lewis6991/gitsigns.nvim',
        config = function() require('gitsigns').setup() end
    }
    use { "akinsho/toggleterm.nvim",
        disable = true,
        tag = '*',
        config = function() require("toggleterm").setup() end
    }
    use '~/semantic'

    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function ()
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

    use{
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
            require("trouble").setup ({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end
    }

    use{
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            local saga = require("lspsaga")

            saga.init_lsp_saga({
                -- your configuration
            })
        end,
    }
    use {
        'simrat39/symbols-outline.nvim',
        config = function () require("symbols-outline").setup() end
    }

end)
