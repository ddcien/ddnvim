local telescope = require("telescope.builtin")
local lspconfig = require('lspconfig')
local semantic = require("semantic")


local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set('n', 'gd', telescope.lsp_definitions, bufopts)
    vim.keymap.set('n', 'gr', telescope.lsp_references, bufopts)
    vim.keymap.set('n', 'gi', telescope.lsp_implementations, bufopts)

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, bufopts)

    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

    semantic.refresh_buf_client(client, bufnr)
end


local capabilities = semantic.update_client_capabilities(require("cmp_nvim_lsp").default_capabilities())


lspconfig.clangd.setup ({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.sumneko_lua.setup({
    cmd = {"/home/richard/.local/sumneko/bin/lua-language-server"},
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = {'vim'} }
        }
    }
})

-----------------------------------------------
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<c-k>', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<c-j>', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)

vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    severity_sort = false,
    float = {}
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-----------------------------------------------
