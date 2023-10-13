vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1

vim.g.gruvbox_contrast_dark = 'hard'
vim.api.nvim_cmd({cmd = 'colorscheme', args = {'gruvbox'}}, {})

local hl = function(hl_group, value)
  vim.api.nvim_set_hl(0, hl_group, value)
end

hl('Normal', {fg = '#ebdbb2', bg = 'None'})
hl('SignColumn', {bg = 'None'})
hl('WinSeparator', {fg = '#665c54', bg = 'None'})
hl('markdownError', {link = 'None'})

hl('CursorLineNr', {fg = '#fabd2f', bg = 'None'})
hl('CursorLine', {bg = '#444444'})

hl('CurSearch', {link = 'IncSearch'})

hl('NonText', {fg = '#6c6c6c', bg = 'None'})
hl('TrailingWhitespace', {fg = '#ffffff', bg = '#ff0000', bold = true})

vim.api.nvim_cmd({cmd = 'match', args = {'TrailingWhitespace', [[/\s\+$/]]}}, {})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function(event)
    if vim.api.nvim_get_option_value('ft', {buf = event.buf}) == 'help' or
       string.sub(event.file, 1, 7) == 'term://' or
       (event.file == '' and
        vim.api.nvim_get_option_value('ft', {buf = event.buf}) == '') then
      vim.api.nvim_cmd({cmd = 'match', args = {'none'}}, {})
    else
      for _, match in ipairs(vim.fn.getmatches()) do
        if match.group == 'TrailingWhitespace' then
          return
        end
      end

      vim.api.nvim_cmd({cmd = 'match', args = {'TrailingWhitespace', [[/\s\+$/]]}}, {})
    end
  end,
})

vim.api.nvim_create_autocmd('WinEnter', {
  pattern = '*',
  callback = function(event)
    if event.file ~= '' or
       vim.api.nvim_get_option_value('ft', {buf = event.buf}) ~= '' then
      for _, match in ipairs(vim.fn.getmatches()) do
        if match.group == 'TrailingWhitespace' then
          return
        end
      end

      vim.api.nvim_cmd({cmd = 'match', args = {'TrailingWhitespace', [[/\s\+$/]]}}, {})
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'TelescopePrompt',
  command = 'match none',
})

vim.api.nvim_create_autocmd('TermEnter', {
  pattern = '*',
  command = 'match none',
})

hl('ColorColumn', {bg = '#555555'})
hl('Todo', {fg = '#1d2021', bg = '#fe8019', bold = true})

hl('Pmenu', {fg = '#ebdbb2', bg = '#4a4340'})
hl('PmenuSel', {fg = '#282828', bg = '#b8bb26', bold = true})
hl('NormalFloat', {link = 'Pmenu'})
hl('FloatBorder', {fg = '#ebdbb2', bg = 'none'})

hl('CmpItemAbbrMatch', {link = 'Special'})
hl('CmpItemAbbrMatchFuzzy', {link = 'CmpItemAbbrMatch'})
hl('CmpItemKind', {link = 'Keyword'})
hl('CmpItemMenu', {link = 'CmpItemAbbrDeprecated'})
hl('cmp_ghost_text', {fg = '#d3869b', bg = '#222222'})
hl('cmp_doc_border', {fg = 'none', bg = 'none'})

hl('TelescopeBorder', {fg = '#fe8019'})
hl('TelescopeSelection', {link = 'CursorLine'})
hl('TelescopeSelectionCaret', {fg = '#fe8019', bg = '#444444', bold = true})
hl('TelescopePreviewMessageFillchar', {fg = '#b7ab99'})

hl('GitSignsAdd', {fg = '#b8bb26', bg = 'none'})
hl('GitSignsChange', {fg = '#83a598', bg = 'none'})
hl('GitSignsDelete', {fg = '#fb4934', bg = 'none'})

hl('DiagnosticError', {fg = '#ff0000'})
hl('DiagnosticHint', {fg = '#d3d3d3'})
hl('DiagnosticWarn', {fg = '#ffa500'})
hl('DiagnosticInfo', {fg = '#add8e6'})

hl('DiagnosticVirtualTextError', {fg = '#ff0000', bg = '#581818'})
hl('DiagnosticVirtualTextHint', {fg = '#d3d3d3', bg = '#4c4f4f'})
hl('DiagnosticVirtualTextWarn', {fg = '#ffa500', bg = '#584318'})
hl('DiagnosticVirtualTextInfo', {fg = '#add8e6', bg = '#425054'})

hl('DiagnosticUnderlineError', {sp = '#ff0000', underline = true})
hl('DiagnosticUnderlineHint', {sp = '#d3d3d3', underline = true})
hl('DiagnosticUnderlineWarn', {sp = '#ffa500', underline = true})
hl('DiagnosticUnderlineInfo', {sp = '#add8e6', underline = true})

hl('DiagnosticLineNrError', {fg = '#ff0000', bg = 'none'})
hl('DiagnosticLineNrHint', {fg = '#d3d3d3', bg = 'none'})
hl('DiagnosticLineNrWarn', {fg = '#ffa500', bg = 'none'})
hl('DiagnosticLineNrInfo', {fg = '#add8e6', bg = 'none'})
vim.fn.sign_define('DiagnosticSignError', {numhl = 'DiagnosticLineNrError'})
vim.fn.sign_define('DiagnosticSignHint', {numhl = 'DiagnosticLineNrHint'})
vim.fn.sign_define('DiagnosticSignWarn', {numhl = 'DiagnosticLineNrWarn'})
vim.fn.sign_define('DiagnosticSignInfo', {numhl = 'DiagnosticLineNrInfo'})

hl('LspSignatureActiveParameter', {bg = '#444444', bold = true})
hl('LspCodeActionSign', {fg = '#fabd2f', bg = 'none'})
vim.fn.sign_define('LspCodeAction', {text = '', texthl = 'LspCodeActionSign'})

hl('lualine_section_separator', {fg = '#b7ab99', bg = '#524B47'})
hl('lualine_section_border', {fg = '#524B47', bg = '#3c3836'})
hl('lualine_section_border_bg_none', {fg = '#524B47', bg = 'none'})
hl('lualine_section_border_active', {fg = '#b7ab99', bg = '#3c3836'})
hl('lualine_section_border_active_bg_none', {fg = '#b7ab99', bg = 'none'})
hl('lualine_buffers_hidden', {fg = '#282828', bg = '#83a598'})
hl('lualine_buffers_hidden_border', {fg = '#83a598', bg = '#3c3836'})
hl('lualine_lsp_border', {fg = '#8ec07c', bg = '#3c3836'})
hl('lualine_lsp_icon', {fg = '#1d2021', bg = '#8ec07c'})
hl('lualine_lsp_clients', {fg = '#8ec07c', bg = '#524B47'})
hl('lualine_git_border', {fg = '#f03c2e', bg = '#3c3836'})
hl('lualine_git_icon', {fg = '#ffffff', bg = '#f03c2e'})
hl('lualine_git_branch', {fg = '#f03c2e', bg = '#524B47'})
hl('lualine_encoding_border', {fg = '#83a598', bg = '#3c3836'})
hl('lualine_encoding_icon', {fg = '#1d2021', bg = '#83a598'})
hl('lualine_encoding_type', {fg = '#83a598', bg = '#524B47'})
hl('lualine_fileformat_border_unix', {fg = '#b8bb26', bg = '#3c3836'})
hl('lualine_fileformat_icon_unix', {fg = '#1d2021', bg = '#b8bb26'})
hl('lualine_fileformat_type_unix', {fg = '#b8bb26', bg = '#524B47'})
hl('lualine_fileformat_border_non_unix', {fg = '#fb4934', bg = '#3c3836'})
hl('lualine_fileformat_icon_non_unix', {fg = '#ffffff', bg = '#fb4934'})
hl('lualine_fileformat_type_non_unix', {fg = '#fb4934', bg = '#524B47'})
hl('lualine_progress_border', {fg = '#d3869b', bg = '#3c3836'})
hl('lualine_progress_icon', {fg = '#1d2021', bg = '#d3869b'})
hl('lualine_progress_progress', {fg = '#d3869b', bg = '#524B47'})
hl('lualine_loc_border', {fg = '#fabd2f', bg = '#3c3836'})
hl('lualine_loc_icon', {fg = '#1d2021', bg = '#fabd2f'})
hl('lualine_loc_loc', {fg = '#fabd2f', bg = '#524B47'})

vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function(event)
    vim.highlight.on_yank({higroup = 'IncSearch', timeout = 100})
  end,
})

local ts_highlights = {
  ['@annotation'] = {link = 'PreProc'},
  ['@attribute'] = {link = 'PreProc'},
  ['@boolean'] = {link = 'Boolean'},
  ['@character'] = {link = 'Character'},
  ['@character.special'] = {link = 'SpecialChar'},
  ['@comment'] = {link = 'Comment'},
  ['@conditional'] = {link = 'Conditional'},
  ['@constant'] = {link = 'Constant'},
  ['@constant.builtin'] = {link = 'Special'},
  ['@constant.macro'] = {link = 'Define'},
  ['@constructor'] = {link = 'Special'},
  ['@debug'] = {link = 'Debug'},
  ['@define'] = {link = 'Define'},
  ['@exception'] = {link = 'Exception'},
  ['@field'] = {link = 'Identifier'},
  ['@float'] = {link = 'Float'},
  ['@function'] = {link = 'Function'},
  ['@function.builtin'] = {link = 'Special'},
  ['@function.call'] = {link = 'Function'},
  ['@function.macro']  = {link = 'Macro'},
  ['@include'] = {link = 'Include'},
  ['@none'] = {bg = 'NONE', fg = 'NONE'},
  ['@keyword'] = {link = 'Keyword'},
  ['@keyword.function'] = {link = 'Keyword'},
  ['@keyword.operator'] = {link = 'Keyword'},
  ['@keyword.return'] = {link = 'Keyword'},
  ['@label'] = {link = 'Label'},
  ['@method'] = {link = 'Function'},
  ['@method.call'] = {link = 'Function'},
  ['@namespace'] = {link = 'Include'},
  ['@number'] = {link = 'Number'},
  ['@operator'] = {link = 'Operator'},
  ['@parameter'] = {link = 'Identifier'},
  ['@parameter.reference'] = {link = 'Identifier'},
  ['@preproc'] = {link = 'PreProc'},
  ['@property'] = {link = 'Identifier'},
  ['@punctuation.bracket'] = {link = 'Delimiter'},
  ['@punctuation.delimiter'] = {link = 'Delimiter'},
  ['@punctuation.special'] = {link = 'Delimiter'},
  ['@repeat'] = {link = 'Repeat'},
  ['@storageclass'] = {link = 'StorageClass'},
  ['@string'] = {link = 'String'},
  ['@string.escape'] = {link = 'SpecialChar'},
  ['@string.regex'] = {link = 'String'},
  ['@string.special'] = {link = 'SpecialChar'},
  ['@symbol'] = {link = 'Identifier'},
  ['@tag'] = {link = 'Label'},
  ['@tag.attribute'] = {link = 'Identifier'},
  ['@tag.delimiter'] = {link = 'Delimiter'},
  ['@text'] = {link = 'Normal'},
  ['@text.danger'] = {link = 'ErrorMsg'},
  ['@text.emphasis'] = {italic = true},
  ['@text.environment'] = {link = 'Macro'},
  ['@text.environment.name'] = {link = 'Type'},
  ['@text.literal'] = {link = 'String'},
  ['@text.math'] = {link = 'Special'},
  ['@text.note'] = {link = 'Todo'},
  ['@text.reference'] = {link = 'Constant'},
  ['@text.strike'] = {strikethrough = true},
  ['@text.strong'] = {bold = true},
  ['@text.title'] = {link = 'Title'},
  ['@text.underline'] = {underline = true},
  ['@text.uri'] = {link = 'Underlined'},
  ['@text.warning'] = {link = 'Todo'},
  ['@todo'] = {link = 'Todo'},
  ['@type'] = {link = 'Type'},
  ['@type.builtin'] = {link = 'Type'},
  ['@type.definition'] = {link = 'Typedef'},
  ['@type.qualifier'] = {link = 'Type'},
  ['@variable'] = {link = 'Normal'},
  ['@variable.builtin'] = {link = 'Special'},
}

for hl_group, value in pairs(ts_highlights) do
  value.default = true
  hl(hl_group, value)
end

local cmp_kind_highlights = {
  ['CmpItemKindArray'] = '@type',
  ['CmpItemKindBoolean'] = '@boolean',
  ['CmpItemKindClass'] = '@type',
  ['CmpItemKindColor'] = '@constant',
  ['CmpItemKindConstant'] = '@constant',
  ['CmpItemKindConstructor'] = '@constructor',
  ['CmpItemKindEnum'] = '@type',
  ['CmpItemKindEnumMember'] = '@constant',
  ['CmpItemKindEvent'] = '@type',
  ['CmpItemKindField'] = '@field',
  ['CmpItemKindFile'] = '@include',
  ['CmpItemKindFolder'] = '@include',
  ['CmpItemKindFunction'] = '@function',
  ['CmpItemKindInterface'] = '@type',
  ['CmpItemKindKey'] = '@keyword',
  ['CmpItemKindKeyword'] = '@keyword',
  ['CmpItemKindMethod'] = '@method',
  ['CmpItemKindModule'] = '@include',
  ['CmpItemKindNamespace'] = '@namespace',
  ['CmpItemKindNull'] = '@constant',
  ['CmpItemKindNumber'] = '@number',
  ['CmpItemKindObject'] = '@storageclass',
  ['CmpItemKindOperator'] = '@operator',
  ['CmpItemKindPackage'] = '@include',
  ['CmpItemKindProperty'] = '@property',
  ['CmpItemKindReference'] = '@parameter.reference',
  ['CmpItemKindSnippet'] = '@constant',
  ['CmpItemKindString'] = '@string',
  ['CmpItemKindStruct'] = '@type',
  ['CmpItemKindText'] = '@string',
  ['CmpItemKindTypeParameter'] = '@parameter',
  ['CmpItemKindUnit'] = '@constant',
  ['CmpItemKindValue'] = '@constant',
  ['CmpItemKindVariable'] = '@field',
}

for cmp_item_kind, hl_group in pairs(cmp_kind_highlights) do
  only_fg_hl = {fg = string.format('#%06x', vim.api.nvim_get_hl(0, {name = hl_group, link = false}).fg)}
  hl(cmp_item_kind, only_fg_hl)
end
