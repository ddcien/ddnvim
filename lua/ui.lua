local orig_util_open_floating_preview = nil

local function _update_completion_kinds(icons)
    local kinds = vim.lsp.protocol.CompletionItemKind
    for i, kind in ipairs(kinds) do
        kinds[i] = icons[kind] or kind
    end
end

local function _update_open_floating_preview(border)
    if not orig_util_open_floating_preview then
        orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    end
    if not border then
        return
    end

    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
end

