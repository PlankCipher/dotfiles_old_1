require('nvim-web-devicons').setup({
  strict = true,
  override_by_filename = {
    ['send help'] = {
      icon = '',
      color = '#fabd2f',
      name = 'Dashboard'
    },
    ['telescope'] = {
      icon = '󰭎',
      color = '#83a598',
      name = 'Telescope'
    },
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'TelescopePrompt',
  callback = function(e)
    vim.api.nvim_buf_set_name(e.buf, 'telescope')
  end,
})
