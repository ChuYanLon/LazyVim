local function merge(left, right)
  local result = {}
  for k, v in pairs(left) do
    result[k] = v
  end
  for k, v in pairs(right) do
    result[k] = v
  end
  return result
end

local function create_keys(maps, opts)
  opts = opts or {}
  for _, map in pairs(maps) do
    local default_opts = { silent = true, nowait = true }
    map[4] = map[4] or {}
    map[4] = merge(default_opts, merge(opts, map[4]))

    if map[4].buffer then
      map[4].buffer = nil
      vim.api.nvim_buf_set_keymap(0, map[1], map[2], map[3], map[4])
    else
      vim.keymap.set(map[1], map[2], map[3], map[4])
    end
  end
end

return {
  {
    "neoclide/coc.nvim",
    -- branch = "release",
    build = "npm run build",
    cmd = {
      "CocCommand",
      "CocConfig",
      "CocDiagnostics",
      "CocDisable",
      "CocEnable",
      "CocInfo",
      "CocInstall",
      "CocList",
      "CocLocalConfig",
      "CocOpenLog",
      "CocOutline",
      "CocPrintErrors",
      "CocRestart",
      "CocSearch",
      "CocStart",
      "CocUninstall",
      "CocUpdate",
      "CocUpdateSync",
      "CocWatch",
    },
    event = { "InsertEnter", "User LazyFile" },
    config = function()
      vim.opt.cmdheight = 1
      vim.g.coc_snippet_next = "<Tab>"
      vim.g.coc_snippet_prev = "<S-Tab>"
      vim.g.coc_global_extensions = vim.list_extend(vim.g.coc_global_extensions, {
        "coc-marketplace",
        "coc-prettier",
        "coc-translator"
      })

      function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end

      function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end

      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
      vim.api.nvim_create_autocmd("FileType", {
        group = "CocGroup",
        pattern = "typescript,json",
        command = "setl formatexpr=CocAction('formatSelected')",
        desc = "Setup formatexpr specified filetype(s)."
      })

      create_keys({
        { "i", "<C-j>",      'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', { silent = true, noremap = true, expr = true, replace_keycodes = false } },
        { "i", "<C-k>",      [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],                                         { silent = true, noremap = true, expr = true, replace_keycodes = false } },
        { "i", "<Cr>",       [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],       { silent = true, noremap = true, expr = true, replace_keycodes = false } },
        { "n", "K",          '<CMD>lua _G.show_docs()<CR>',                                                              { silent = true } },
        { "i", "<c-i>",      "coc#refresh()",                                                                            { silent = true, expr = true } },
        { 'n', 'gd',         '<Plug>(coc-definition)',                                                                   { desc = 'Go to definition' } },
        { 'n', 'gy',         '<Plug>(coc-type-definition)',                                                              { desc = 'Go to type definition' } },
        { 'n', 'gi',         '<Plug>(coc-implementation)',                                                               { desc = 'Go to implementation' } },
        { 'n', 'gr',         '<Plug>(coc-references)',                                                                   { desc = 'Find references' } },
        { 'x', 'if',         '<Plug>(coc-funcobj-i)',                                                                    { desc = 'Inner function text object (visual)' } },
        { 'o', 'if',         '<Plug>(coc-funcobj-i)',                                                                    { desc = 'Inner function text object (operator-pending)' } },
        { 'x', 'af',         '<Plug>(coc-funcobj-a)',                                                                    { desc = 'Around function text object (visual)' } },
        { 'o', 'af',         '<Plug>(coc-funcobj-a)',                                                                    { desc = 'Around function text object (operator-pending)' } },
        { 'x', 'ic',         '<Plug>(coc-classobj-i)',                                                                   { desc = 'Inner class text object (visual)' } },
        { 'o', 'ic',         '<Plug>(coc-classobj-i)',                                                                   { desc = 'Inner class text object (operator-pending)' } },
        { 'x', 'ac',         '<Plug>(coc-classobj-a)',                                                                   { desc = 'Around class text object (visual)' } },
        { 'o', 'ac',         '<Plug>(coc-classobj-a)',                                                                   { desc = 'Around class text object (operator-pending)' } },
        { 'n', '<leader>lr', '<Plug>(coc-codeaction-refactor)',                                                          { desc = 'refactor' } },
        { 'x', '<leader>lr', '<Plug>(coc-codeaction-refactor-selected)',                                                 { desc = 'refactor' } },
        { 'n', '<leader>cf', ':Format<CR>',                                                                              { desc = 'format' } },
        { 'x', '<leader>cf', '<Plug>(coc-format-selected)',                                                              { desc = 'format' } },
        { 'n', '<leader>la', '<Plug>(coc-codeaction-line)',                                                              { desc = 'action' } },
        { 'x', '<leader>la', '<Plug>(coc-codeaction-selected)',                                                          { desc = 'action' } },
        { 'n', '<leader>lA', '<Plug>(coc-codeaction-source)',                                                            { desc = 'sourceAction' } },
        { 'n', '<leader>ll', '<Plug>(coc-codelens-action)',                                                              { desc = 'codelensAction' } },
        { 'n', '<leader>cr', '<Plug>(coc-rename)',                                                                       { desc = 'rename' } },
        { 'n', '<space>cs',  ':<C-u>CocOutline<CR>',                                                                     { desc = 'outline' } },
        { 'n', '<leader>lq', '<Plug>(coc-fix-current)',                                                                  { desc = 'fix' } },
        { 'n', '<space>xx',  ':<C-u>CocDiagnostics<CR>',                                                                 { desc = 'diagnostics' } },
        { 'n', '<space>xs',  ':<C-u>CocList diagnostics<CR>',                                                            { desc = 'all diagnostics' } },
        { 'n', '[d',         '<Plug>(coc-diagnostic-prev)',                                                              { desc = 'previous diagnostic' } },
        { 'n', ']d',         '<Plug>(coc-diagnostic-next)',                                                              { desc = 'next diagnostic' } },
        { 'n', '<leader>p',  '',                                                                                         { desc = 'package', silent = true } },
        { 'n', '<leader>pc', ':<C-u>CocList commands<CR>',                                                               { desc = 'commands' } },
        { 'n', '<leader>pp', ':<C-u>CocList<CR>',                                                                        { desc = 'List' } },
        { 'n', '<leader>pl', ':<C-u>Lazy<CR>',                                                                           { desc = 'Lazy' } },
        { 'n', '<leader>ps', ':<C-u>CocList services<CR>',                                                               { desc = 'services' } },
        { 'n', '<leader>pm', ':<C-u>CocList marketplace<CR>',                                                            { desc = 'marketplace' } },
        { 'n', '<leader>pe', ':<C-u>CocList extensions<CR>',                                                             { desc = 'extensions' } },
        { 'n', '<leader>pr', ':CocRestart<CR>',                                                                          { desc = 'restart' } },
        { 'n', '<C-n>',      'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-n>"',                                   { expr = true, desc = 'Scroll down in Coc float' } },
        { 'n', '<C-p>',      'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-p>"',                                   { expr = true, desc = 'Scroll up in Coc float' } },
        { 'i', '<C-n>',      'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',                     { expr = true, desc = 'Insert mode: Scroll down float' } },
        { 'i', '<C-p>',      'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',                      { expr = true, desc = 'Insert mode: Scroll up float' } },
        { 'v', '<C-n>',      'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-n>"',                                   { expr = true, desc = 'Visual mode: Scroll down float' } },
        { 'v', '<C-p>',      'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-p>"',                                   { expr = true, desc = 'Visual mode: Scroll up float' } },
        { 'n', 'mm',         '<Plug>(coc-translator-p)',                                                                 { desc = 'translate' } },
        { 'v', 'mm',         '<Plug>(coc-translator-pv)',                                                                { desc = 'translate' } },
      })
    end,
  },
  {
    "mlaursen/vim-react-snippets",
    config = function()
      require("vim-react-snippets").setup({})
    end,
  },
  { "rafamadriz/friendly-snippets", lazy = true },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      preset = "helix",
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>p", desc = "package", icon = "󰏖 " },
          { "<leader>l", desc = "lsp", icon = " ", },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "stylua" and tool ~= "shfmt"
      end, opts.ensure_installed or {})
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 1, function()
        local coc_status = vim.g.coc_status or ''
        return coc_status ~= '' and ' ' .. coc_status or ''
      end)
    end,
  },
  { "neovim/nvim-lspconfig",        enabled = false },
  { "hrsh7th/nvim-cmp",             enabled = false },
  { "hrsh7th/cmp-nvim-lsp",         enabled = false },
  { "saghen/blink.cmp",             enabled = false },
  { "stevearc/conform.nvim",        enabled = false },
  { "mfussenegger/nvim-lint",       enabled = false },
  { "folke/noice.nvim",             enabled = false },
  { "folke/lazydev.nvim",           enabled = false },
  { "lewis6991/gitsigns.nvim",      enabled = false },
  { "catppuccin/nvim",              enabled = false },
  { "folke/tokyonight.nvim",        enabled = false },
  { "zeioth/garbage-day.nvim",      enabled = false },
  { "uga-rosa/translate.nvim",      enabled = false }
}
