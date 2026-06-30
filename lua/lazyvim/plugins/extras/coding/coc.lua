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

return {
  { "neovim/nvim-lspconfig",     optional = true, enabled = false },
  { "hrsh7th/nvim-cmp",          optional = true, enabled = false },
  { "hrsh7th/cmp-nvim-lsp",      optional = true, enabled = false },
  { "saghen/blink.cmp",          optional = true, enabled = false },
  { "stevearc/conform.nvim",     optional = true, enabled = false },
  { "mfussenegger/nvim-lint",    optional = true, enabled = false },
  { "catppuccin/nvim",           optional = true, enabled = false },
  { "mason-org/mason.nvim",      optional = true, enabled = false },
  { "folke/lazydev.nvim",        optional = true, enabled = false },
  { "folke/noice.nvim",          optional = true, enabled = false },
  { "folke/trouble.nvim",        optional = true, enabled = false },
  { "nvim-lualine/lualine.nvim", optional = true, enabled = false },
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function(_, opts)
      opts.options.diagnostics = "coc"
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>p", desc = "package", icon = "󰏖 " },
          { "<leader>f", group = " find" },
          { "<leader>s", group = " search" },
          { "<leader>g", group = " git" },
          { "<leader>c", group = " lsp" },
          { "<leader>l", group = "Lazy" },
          { "<leader>t", group = " terminal" },
          { "<leader>b", group = " buffer" },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      opts.root_spec = vim.tbl_filter(function(v)
        return v ~= "lsp"
      end, opts.root_spec or { { ".git", "lua" }, "cwd" })
    end,
  },
  {
    "neoclide/coc.nvim",
    branch = "master",
    build = "npm ci",
    event = { "InsertEnter", "User LazyFile" },
    config = function()
      vim.g.coc_global_extensions = merge(
        { "coc-json", "coc-vscode-loader", "coc-snippets" },
        vim.g.coc_global_extensions or {}
      )
      vim.g.coc_loader_global_extensions = merge(
        {},
        vim.g.coc_loader_global_extensions or {}
      )
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

      vim.keymap.set("n", "<leader>cl", ":<C-u>CocInfo<Cr>", { silent = true, nowait = true, desc = "Lsp Info" })

      vim.keymap.set("n", "<leader>cc", "<Plug>(coc-codelens-action)",
        { silent = true, nowait = true, desc = "Run Codelens" })
      vim.keymap.set("n", "<leader>ca", "<Plug>(coc-codeaction-line)",
        { silent = true, nowait = true, desc = "Code Action" })
      vim.keymap.set("x", "<leader>ca", "<Plug>(coc-codeaction-selected)",
        { silent = true, nowait = true, desc = "Code Action" })
      vim.keymap.set("n", "<leader>cA", "<Plug>(coc-codeaction-source)",
        { silent = true, nowait = true, desc = "Source Action" })

      vim.keymap.set("n", "<leader>cq", "<Plug>(coc-fix-current)", { silent = true, nowait = true, desc = "Fix Current" })

      vim.keymap.set("n", "<leader>cm", ":<C-u>CocCommand loader.open<CR>",
        { silent = true, nowait = true, desc = "Loader" })


      vim.keymap.set("n", "<leader>cf", ":Format<CR>", { silent = true, nowait = true, desc = "Format" })
      vim.keymap.set("x", "<leader>cf", "<Plug>(coc-format-selected)", { silent = true, nowait = true, desc = "Format" })

      vim.keymap.set("n", "<leader>cr", "<Plug>(coc-rename)", { silent = true, nowait = true, desc = "Rename" })


      vim.keymap.set("n", "<leader>cs", ":<C-u>CocOutline<CR>", { silent = true, nowait = true, desc = "Symbols" })
      vim.keymap.set("n", "<leader>cS", ":<C-u>CocList outline<CR>", { silent = true, nowait = true, desc = "Symbols" })


      vim.keymap.set("n", "[d", "<Plug>(coc-diagnostic-prev)", { silent = true, nowait = true, desc = "Prev Diagnostic" })
      vim.keymap.set("n", "]d", "<Plug>(coc-diagnostic-next)", { silent = true, nowait = true, desc = "Next Diagnostic" })


      vim.keymap.set('n', '<C-n>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-n>"',
        { silent = true, nowait = true, expr = true, desc = 'Scroll down in Coc float' })
      vim.keymap.set('n', '<C-p>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-p>"',
        { silent = true, nowait = true, expr = true, desc = 'Scroll up in Coc float' })
      vim.keymap.set('i', '<C-n>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',
        { silent = true, nowait = true, expr = true, desc = 'Insert mode: Scroll down float' })
      vim.keymap.set('i', '<C-p>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',
        { silent = true, nowait = true, expr = true, desc = 'Insert mode: Scroll up float' })
      vim.keymap.set('v', '<C-n>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-n>"',
        { silent = true, nowait = true, expr = true, desc = 'Visual mode: Scroll down float' })
      vim.keymap.set('v', '<C-p>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-p>"',
        { silent = true, nowait = true, expr = true, desc = 'Visual mode: Scroll up float' })


      vim.keymap.set('n', 'mm', '<Plug>(coc-translator-p)', { desc = 'translate', silent = true, nowait = true })
      vim.keymap.set('v', 'mm', '<Plug>(coc-translator-pv)', { desc = 'translate', silent = true, nowait = true })


      vim.keymap.set('n', '<leader>pc', ':<C-u>CocList commands<CR>', { desc = 'commands', silent = true, nowait = true })
      vim.keymap.set('n', '<leader>pl', ':<C-u>CocList<CR>', { desc = 'List', silent = true, nowait = true })
      vim.keymap.set('n', '<leader>ps', ':<C-u>CocList services<CR>', { desc = 'services', silent = true, nowait = true })
      vim.keymap.set('n', '<leader>pe', ':<C-u>CocList extensions<CR>',
        { desc = 'extensions', silent = true, nowait = true })
      vim.keymap.set('n', '<leader>pr', ':CocRestart<CR>', { desc = 'restart', silent = true, nowait = true })


      vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { desc = 'Goto Definition', silent = true, nowait = true })
      vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)',
        { desc = 'Goto T[y]pe Definition', silent = true, nowait = true })
      vim.keymap.set('n', 'gI', '<Plug>(coc-implementation)',
        { desc = 'Goto Implementation', silent = true, nowait = true })
      vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { desc = 'References', silent = true, nowait = true })


      vim.keymap.set("i", "<C-j>",
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
        { silent = true, noremap = true, expr = true, replace_keycodes = false, nowait = true })
      vim.keymap.set("i", "<C-k>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],
        { silent = true, noremap = true, expr = true, replace_keycodes = false, nowait = true })
      vim.keymap.set("i", "<Cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
        { silent = true, noremap = true, expr = true, replace_keycodes = false, nowait = true })
      vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true, nowait = true })
      vim.keymap.set("i", "<c-i>", "coc#refresh()", { silent = true, expr = true, nowait = true })


      vim.keymap.set('n', '<leader>r', '<Plug>(coc-codeaction-refactor)',
        { desc = 'refactor', silent = true, nowait = true })
      vim.keymap.set('x', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)',
        { desc = 'refactor', silent = true, nowait = true })


      vim.keymap.set('n', '<leader>xx', ':<C-u>CocDiagnostics<CR>',
        { desc = 'Buffer Diagnostic', silent = true, nowait = true })
      vim.keymap.set('n', '<leader>xl', ':<C-u>CocList diagnostics<CR>',
        { desc = 'Diagnostics', silent = true, nowait = true })
    end,
  },
}
