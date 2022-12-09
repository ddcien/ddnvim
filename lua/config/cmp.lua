local cmp = require 'cmp'
local types = require("cmp.types")
local str = require("cmp.utils.str")
local luasnip = require 'luasnip'
local lspkind = require('lspkind')

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true, }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'luasnip' },
        { name = 'path' },
    }, {
    }),
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 60,
            ellipsis_char = '...',

            before = function(entry, vim_item)
                local word = entry:get_insert_text()
                if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
                    word = str.oneline(vim.lsp.util.parse_snippet(word))
                    if string.sub(vim_item.abbr, -1, -1) == "~" then
                        word = word .. "~"
                    end
                else
                    word = str.oneline(word)
                end
                vim_item.abbr = word
                return vim_item
            end
        })
    }
}
