vim.g.neoformat_try_formatprg = 0
vim.g.neoformat_basic_format_align = 0
vim.g.neoformat_basic_format_retab = 0
vim.g.neoformat_basic_format_trim = 1
vim.g.neoformat_run_all_formatters = 0
vim.g.neoformat_only_msg_on_error = 0
vim.g.neoformat_try_node_exe = 0

vim.g.neoformat_enabled_html = {'prettierd'}
vim.g.neoformat_enabled_css = {'prettierd'}
vim.g.neoformat_enabled_javascript = {'prettierd'}
vim.g.neoformat_enabled_javascriptreact = {'prettierd'}
vim.g.neoformat_enabled_typescript = {'prettierd'}
vim.g.neoformat_enabled_typescriptreact = {'prettierd'}
vim.g.neoformat_enabled_json = {'prettierd'}
vim.g.neoformat_enabled_markdown = {'prettierd'}

vim.g.neoformat_python_yapf = {
  exe = 'yapf',
  args = {'--style $HOME/.config/nvim/lua/plankcipher/plugins/formatting/.style.yapf'},
  stdin = 1,
}
vim.g.neoformat_enabled_python = {'yapf'}

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {'*.html', '*.css', '*.js', '*.jsx', '*.ts', '*.tsx', '*.json', '*.md', '*.py'},
  command = 'Neoformat',
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {'*.c', '*.cpp', '*.h'},
  callback = function() vim.lsp.buf.format({async = false}) end,
})
