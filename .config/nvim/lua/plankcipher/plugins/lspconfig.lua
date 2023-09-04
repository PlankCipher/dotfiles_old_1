local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  local bufopts = {noremap=true, silent=true, buffer=bufnr}
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)

  if client.server_capabilities.documentHighlightProvider then
    local highlight = {fg = '#fbf1c7', bg = '#66542a'}
    vim.api.nvim_set_hl(0, 'LspReferenceRead', highlight)
    vim.api.nvim_set_hl(0, 'LspReferenceText', highlight)
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', highlight)

    vim.api.nvim_create_augroup('lsp_document_highlight', {
      clear = false
    })
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = 'lsp_document_highlight',
    })
    vim.api.nvim_create_autocmd('CursorHold', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  client.server_capabilities.semanticTokensProvider = nil
end

local lsp_flags = {
  debounce_text_changes = 100,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = {'html', 'cssls', 'emmet_ls', 'tsserver', 'clangd', 'pyright'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  })
end

lspconfig.eslint.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
  settings = {
    packageManager = 'yarn',
  }
})

lspconfig.phpactor.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
  init_options = {
    ['language_server.diagnostic_sleep_time'] = 100,
    ['language_server_php_cs_fixer.enabled'] = true,
    ['language_server_php_cs_fixer.bin'] = '~/.config/composer/vendor/bin/php-cs-fixer',
  },
})

vim.diagnostic.config({
  virtual_text = {
    source = true,
    prefix = '󰓛',
  },
  float = {
    source = true,
    border = 'rounded',
  },
  update_in_insert = true,
  severity_sort = true,
  signs = true,
})

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
