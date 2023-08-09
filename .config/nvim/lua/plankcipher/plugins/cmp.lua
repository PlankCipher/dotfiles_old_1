local luasnip = require('luasnip')
local cmp = require('cmp')

local kind_icons = {
  Text = ' TXT',
  Method = ' MTD',
  Function = '󰊕 FUN',
  Constructor = ' CON',
  Field = '󰜢 FLD',
  Variable = '󰀫 VAR',
  Class = '󰠱 CLS',
  Interface = ' IFC',
  Module = ' MOD',
  Property = '󰜢 PRP',
  Unit = ' UNT',
  Value = '󰎠 VAL',
  Enum = ' ENM',
  Keyword = '󰌋 KWD',
  Snippet = '󰅴 SNP',
  Color = '󰉦 CLR',
  File = '󰈙 FIL',
  Reference = ' REF',
  Folder = ' FDR',
  EnumMember = ' EMR',
  Constant = '󰏿 CNS',
  Struct = '󰙅 STR',
  Event = ' EVN',
  Operator = '󱓉 OPR',
  TypeParameter = ' TYP',
}

cmp.setup({
  view = {
    entries = {name = 'custom', selection_order = 'near_cursor' }
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
    ['<C-j>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    {name = 'path'},
    {name = 'buffer'},
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
  },
  formatting = {
    fields = {'kind', 'abbr', 'menu'},
    format = function(entry, vim_item)
      vim_item.kind = kind_icons[vim_item.kind]
      vim_item.abbr = string.format('│ %s', vim_item.abbr:gsub('^%s+', ''))
      vim_item.menu = string.format('│ %s', ({
        path = '󰈙 PTH',
        buffer = ' BUF',
        nvim_lsp = '󰒓 LSP',
        luasnip = '󰅴 SNP',
      })[entry.source.name])

      return vim_item
    end
  },
  window = {
    completion = {border = 'rounded', col_offset = -9},
    documentation = {border = 'rounded'},
  },
  experimental = {
    ghost_text = {hl_group = 'cmp_ghost_text'},
  }
})
