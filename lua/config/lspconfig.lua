return {
    'neovim/nvim-lspconfig',
    requires = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        local lspconfig = require('lspconfig')
        local telescope = require("telescope.builtin")
        local semantic = require("semantic")

        vim.diagnostic.config({
            underline = true,
            virtual_text = false,
            signs = true,
            update_in_insert = false,
            severity_sort = false,
            float = {
                border = "double",
                source = "always",
                close_events = {}
            }
        })
        local signs = { Error = "", Warn = "", Hint = "", Info = "" }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        local border = {
            { "🭽", "FloatBorder" },
            { "▔", "FloatBorder" },
            { "🭾", "FloatBorder" },
            { "▕", "FloatBorder" },
            { "🭿", "FloatBorder" },
            { "▁", "FloatBorder" },
            { "🭼", "FloatBorder" },
            { "▏", "FloatBorder" },
        }

        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or border
            return orig_util_open_floating_preview(contents, syntax, opts, ...)
        end

        local capabilities = semantic.update_client_capabilities(require("cmp_nvim_lsp").default_capabilities())
        local on_attach = function(client, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gd', telescope.lsp_definitions, bufopts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gt', telescope.lsp_type_definitions, bufopts)
            vim.keymap.set('n', 'gi', telescope.lsp_implementations, bufopts)
            vim.keymap.set('n', 'gr', telescope.lsp_references, bufopts)
            vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<C-J>', vim.diagnostic.goto_next, bufopts)
            vim.keymap.set('n', '<C-K>', vim.diagnostic.goto_prev, bufopts)
            vim.keymap.set('i', '<C-K>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<F3>', function() vim.lsp.buf.format({ bufnr = bufnr, async = true }) end, bufopts)
            vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gf', function()
                vim.lsp.buf.code_action({ apply = true, context = { only = { "quickfix" } } })
            end, bufopts)

            semantic.refresh_buf_client(client, bufnr)

            vim.api.nvim_create_autocmd("CursorHold", {
                buffer = bufnr,
                callback = function()
                    vim.diagnostic.open_float(nil, {
                        focusable = false,
                        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                        scope = 'cursor',
                        border = 'single'
                    })
                end
            })

            if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_augroup('lsp_document_highlight', {
                    clear = false
                })
                vim.api.nvim_clear_autocmds({
                    buffer = bufnr,
                    group = 'lsp_document_highlight',
                })
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    group = 'lsp_document_highlight',
                    buffer = bufnr,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    group = 'lsp_document_highlight',
                    buffer = bufnr,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end


        local servers = {
            ['bashls'] = {
                on_attach = on_attach,
                capabilities = capabilities,
            },
            ['clangd'] = {
                on_attach = on_attach,
                capabilities = capabilities,
            },
            ['rust_analyzer'] = {
                on_attach = on_attach,
                capabilities = capabilities,
            },
            ['pyright'] = {
                on_attach = on_attach,
                capabilities = capabilities,
            },
            ['vimls'] = {
                on_attach = on_attach,
                capabilities = capabilities,
            },
            ['sumneko_lua'] = {
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = { "/work/ddcien/lua-language-server/bin/lua-language-server" },
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {
                                'vim'
                            }
                        }
                    }
                }
            }
        }

        for lsp, option in pairs(servers) do
            lspconfig[lsp].setup(option)
        end
    end
}
