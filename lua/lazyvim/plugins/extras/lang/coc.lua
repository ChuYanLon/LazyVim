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


function _G.get_mode()
  local mode = vim.fn.mode()
  local modes = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    [""] = "V-BLOCK",
    c = "COMMAND",
    r = "REPLACE",
    R = "REPLACE",
    t = "TERM",
    ["!"] = "SHELL"
  }
  return modes[mode] or mode
end

function _G.get_git_branch()
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("\n", "")
  if branch == "" or branch == nil then return "" end
  return " " .. branch
end

function _G.get_file_size()
  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" then return "" end
  local size = vim.fn.getfsize(filename)
  if size <= 0 then return "" end
  if size < 1024 then
    return "[" .. size .. "B]"
  elseif size < 1024 * 1024 then
    return string.format("[%.1fK]", size / 1024)
  else
    return string.format("[%.1fM]", size / 1024 / 1024)
  end
end

function _G.getCocStatusDiagnostic()
  local info = vim.b.coc_diagnostic_info or {}
  if next(info) == nil then return (vim.g.coc_status or '') end

  local msgs = {}
  if (info.error or 0) > 0 then
    table.insert(msgs, '󰅚 ' .. info.error)
  end
  if (info.warning or 0) > 0 then
    table.insert(msgs, '󰀪 ' .. info.warning)
  end

  if (info.info or 0) > 0 then
    table.insert(msgs, '󰋽 ' .. info.info)
  end

  if (info.hint or 0) > 0 or (info.information or 0) > 0 then
    table.insert(msgs, '󰌶 ' .. info.hint or info.information)
  end

  return table.concat(msgs, ' ') .. ' ' .. (vim.g.coc_status or '')
end

return {
  { import = "lazyvim.plugins.extras.editor.snacks_picker" },
  {
    "neoclide/coc.nvim",
    -- branch = "release",
    build = "npm ci",
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
    event = "BufReadPre",
    config = function()
      vim.g.coc_snippet_next = "<Tab>"
      vim.g.coc_snippet_prev = "<S-Tab>"
      vim.opt.cmdheight = 1
      vim.opt.laststatus = 3
      vim.opt.showmode = false
      vim.opt.statusline =
          "%#StatusLine#" ..
          " %{v:lua.get_mode()} " ..
          "%t%{v:lua.get_file_size()}" ..
          "%m%r%w" ..
          " %{v:lua.get_git_branch()} " ..
          "%=" ..
          "%{v:lua.getCocStatusDiagnostic()}" ..
          "%=" ..
          " %l:%c " ..
          "%{&fileencoding}/%{&fileformat} "
      vim.keymap.del("n", "<leader>l")
      vim.keymap.del("n", "<leader>fn")
      vim.keymap.del("n", "<leader>ft")
      vim.keymap.del("n", "<leader>fT")
      vim.keymap.del("n", "<leader>L")
      vim.keymap.del("n", "<leader>K")
      vim.keymap.del("n", "<leader>?")
      vim.keymap.del("n", "<leader>`")
      vim.keymap.set("n", "<leader>p", "<Nop>", { silent = true })
      local cssmodules = vim.g.coc_global_extensions and vim.tbl_contains(vim.g.coc_global_extensions, "coc-cssmodules")
      if cssmodules then
        vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, {
          "cssmodules-language-server",
        })
        vim.fn['coc#config']('languageserver.cssmodules', {
          command = "cssmodules-language-server",
          initializationOptions = { camelCase = "dashes" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          requireRootPattern = 0,
          settings = {},
        })
      end
      vim.g.coc_global_extensions = vim.tbl_filter(function(ext)
          return ext ~= "coc-cssmodules"
        end,
        vim.list_extend(vim.g.coc_global_extensions, {
          "coc-marketplace",
          "coc-prettier",
          "coc-translator"
        }))


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
        { "i", "<C-j>",         'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', { silent = true, noremap = true, expr = true, replace_keycodes = false } },
        { "i", "<C-k>",         [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],                                         { silent = true, noremap = true, expr = true, replace_keycodes = false } },
        { "i", "<Cr>",          [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],       { silent = true, noremap = true, expr = true, replace_keycodes = false } },
        { "n", "K",             '<CMD>lua _G.show_docs()<CR>',                                                              { silent = true } },
        { "i", "<c-i>",         "coc#refresh()",                                                                            { silent = true, expr = true } },
        { 'n', 'gd',            '<Plug>(coc-definition)',                                                                   { desc = 'Go to definition' } },
        { 'n', 'gy',            '<Plug>(coc-type-definition)',                                                              { desc = 'Go to type definition' } },
        { 'n', 'gi',            '<Plug>(coc-implementation)',                                                               { desc = 'Go to implementation' } },
        { 'n', 'gr',            '<Plug>(coc-references)',                                                                   { desc = 'Find references' } },
        { 'x', 'if',            '<Plug>(coc-funcobj-i)',                                                                    { desc = 'Inner function text object (visual)' } },
        { 'o', 'if',            '<Plug>(coc-funcobj-i)',                                                                    { desc = 'Inner function text object (operator-pending)' } },
        { 'x', 'af',            '<Plug>(coc-funcobj-a)',                                                                    { desc = 'Around function text object (visual)' } },
        { 'o', 'af',            '<Plug>(coc-funcobj-a)',                                                                    { desc = 'Around function text object (operator-pending)' } },
        { 'x', 'ic',            '<Plug>(coc-classobj-i)',                                                                   { desc = 'Inner class text object (visual)' } },
        { 'o', 'ic',            '<Plug>(coc-classobj-i)',                                                                   { desc = 'Inner class text object (operator-pending)' } },
        { 'x', 'ac',            '<Plug>(coc-classobj-a)',                                                                   { desc = 'Around class text object (visual)' } },
        { 'o', 'ac',            '<Plug>(coc-classobj-a)',                                                                   { desc = 'Around class text object (operator-pending)' } },
        { 'n', '<leader>lr',    '<Plug>(coc-codeaction-refactor)',                                                          { desc = 'refactor' } },
        { 'x', '<leader>lr',    '<Plug>(coc-codeaction-refactor-selected)',                                                 { desc = 'refactor' } },
        { 'n', '<leader>cf',    ':Format<CR>',                                                                              { desc = 'format' } },
        { 'x', '<leader>cf',    '<Plug>(coc-format-selected)',                                                              { desc = 'format' } },
        { 'n', '<leader>la',    '<Plug>(coc-codeaction-line)',                                                              { desc = 'action' } },
        { 'x', '<leader>la',    '<Plug>(coc-codeaction-selected)',                                                          { desc = 'action' } },
        { 'n', '<leader>lA',    '<Plug>(coc-codeaction-source)',                                                            { desc = 'source Action' } },
        { 'n', '<leader>ll',    '<Plug>(coc-codelens-action)',                                                              { desc = 'codelens' } },
        { 'n', '<leader>cr',    '<Plug>(coc-rename)',                                                                       { desc = 'rename' } },
        { 'n', '<space>cs',     ':<C-u>CocOutline<CR>',                                                                     { desc = 'outline' } },
        { 'n', '<leader>lq',    '<Plug>(coc-fix-current)',                                                                  { desc = 'fix' } },
        { 'n', '<space>xx',     ':<C-u>CocDiagnostics<CR>',                                                                 { desc = 'diagnostics' } },
        { 'n', '<space>xs',     ':<C-u>CocList diagnostics<CR>',                                                            { desc = 'all diagnostics' } },
        { 'n', '[d',            '<Plug>(coc-diagnostic-prev)',                                                              { desc = 'previous diagnostic' } },
        { 'n', ']d',            '<Plug>(coc-diagnostic-next)',                                                              { desc = 'next diagnostic' } },
        { 'n', '<leader>pc',    ':<C-u>CocList commands<CR>',                                                               { desc = 'commands' } },
        { 'n', '<leader>pl',    ':<C-u>CocList<CR>',                                                                        { desc = 'List' } },
        { 'n', '<leader>pL',    ':<C-u>Lazy<CR>',                                                                           { desc = 'Lazy' } },
        { 'n', '<leader>ps',    ':<C-u>CocList services<CR>',                                                               { desc = 'services' } },
        { 'n', '<leader>pm',    ':<C-u>CocList marketplace<CR>',                                                            { desc = 'marketplace' } },
        { 'n', '<leader>pe',    ':<C-u>CocList extensions<CR>',                                                             { desc = 'extensions' } },
        { 'n', '<leader>pr',    ':CocRestart<CR>',                                                                          { desc = 'restart' } },
        { 'n', '<leader>ff',    ':<C-u>CocList files<CR>',                                                                  { desc = 'files' } },
        { 'n', '<leader>fF',    ':<C-u>CocList gfiles<CR>',                                                                 { desc = 'git files' } },
        { 'n', '<leader>fw',    ':<C-u>CocList grep<CR>',                                                                   { desc = 'grep' } },
        { 'n', '<leader>fz',    ':<C-u>CocList lines<CR>',                                                                  { desc = 'lines' } },
        { 'n', '<leader>fh',    ':<C-u>CocList helptags<CR>',                                                               { desc = 'help' } },
        { 'n', '<leader>fb',    ':<C-u>CocList buffers<CR>',                                                                { desc = 'buffers' } },
        { 'n', '<leader>fC',    ':<C-u>CocLocalConfig<CR>',                                                                 { desc = 'local config' } },
        { 'n', '<leader>fc',    ':<C-u>CocConfig<CR>',                                                                      { desc = 'global config' } },
        { 'n', '<leader>fr',    ':<C-u>CocList anyRules<CR>',                                                               { desc = 'anyRules' } },
        { 'n', '<leader>fk',    ':<C-u>CocList maps<CR>',                                                                   { desc = 'keymaps' } },
        { 'n', '<leader>f<Cr>', ':<C-u>CocListResume<CR>',                                                                  { desc = 'resume' } },
        { 'n', '<C-m>',         ':<C-u>CocList files<CR>',                                                                  { desc = 'files' } },
        { 'n', '<C-a>',         ':<C-u>CocList grep<CR>',                                                                   { desc = 'grep' } },
        { 'n', '<C-b>',         ':<C-u>CocList buffers<CR>',                                                                { desc = 'buffers' } },
        { 'n', '<C-.>',         ':<C-u>CocList lines<CR>',                                                                  { desc = 'lines' } },
        { 'n', '<C-n>',         'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-n>"',                                   { expr = true, desc = 'Scroll down in Coc float' } },
        { 'n', '<C-p>',         'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-p>"',                                   { expr = true, desc = 'Scroll up in Coc float' } },
        { 'i', '<C-n>',         'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',                     { expr = true, desc = 'Insert mode: Scroll down float' } },
        { 'i', '<C-p>',         'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',                      { expr = true, desc = 'Insert mode: Scroll up float' } },
        { 'v', '<C-n>',         'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-n>"',                                   { expr = true, desc = 'Visual mode: Scroll down float' } },
        { 'v', '<C-p>',         'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-p>"',                                   { expr = true, desc = 'Visual mode: Scroll up float' } },
        { 'n', 'mm',            '<Plug>(coc-translator-p)',                                                                 { desc = 'translate' } },
        { 'v', 'mm',            '<Plug>(coc-translator-pv)',                                                                { desc = 'translate' } },
      })

      if vim.g.coc_test_plugin then
        vim.opt.runtimepath:prepend(vim.g.coc_test_plugin)
      end
      vim.api.nvim_command("hi! link CocPum Pmenu")
      vim.api.nvim_set_hl(0, "CocSymbolLineSeparator", { fg = "#82AAFF", bg = "NONE", bold = true })
      vim.cmd([[
	hi GitGutterAdd    ctermfg=106 guifg=#29B6F6
	hi GitGutterChange ctermfg=136 guifg=#8BC34A
	hi GitGutterDelete ctermfg=160 guifg=#EF5350
	hi CocFloating ctermbg=6 guibg=(0,0,0,0)
	hi CocSearch ctermfg=6 guifg=#BCEE68 gui=bold
	hi CocInlayHint guifg=#696969 guibg=(0,0,0,0)
	hi CocSymbolUnit  ctermfg=6 guifg=#EF9A9A
	hi CocSymbolNumber ctermfg=5 guifg=#F48FB1
	hi CocSymbolFunction ctermfg=6 guifg=#CE93D8
	hi CocSymbolKey   ctermfg=223 guifg=#B39DDB
	hi CocSymbolKeyword ctermfg=4 guifg=#EF5350
	hi CocSymbolReference ctermfg=223 guifg=#C5CAE9
	hi CocSymbolFolder ctermfg=6 guifg=#42A5F5
	hi CocSymbolVariable ctermfg=223 guifg=#EF5350
	hi CocSymbolNull  ctermfg=4 guifg=#E91E63
	hi CocSymbolValue ctermfg=6 guifg=#4DD0E1
	hi CocSymbolConstant ctermfg=223 guifg=#81C784
	hi CocSymbolText  ctermfg=6 guifg=#C8E6C9
	hi CocSymbolModule ctermfg=4 guifg=#29B6F6
	hi CocSymbolPackage ctermfg=4 guifg=#AB47BC
	hi CocSymbolClass ctermfg=223 guifg=#FFA726
	hi CocSymbolOperator ctermfg=4 guifg=#F8BBD0
	hi CocSymbolStruct ctermfg=4 guifg=#8BC34A
	hi CocSymbolObject ctermfg=6 guifg=#26A69A
	hi CocSymbolMethod ctermfg=6 guifg=#4DB6AC
	hi CocSymbolArray ctermfg=6 guifg=#FF8F00
	hi CocSymbolEnum  ctermfg=6 guifg=#FFB300
	hi CocSymbolField ctermfg=223 guifg=#4FC3F7
	hi CocSymbolInterface ctermfg=6 guifg=#B39DDB
	hi CocSymbolProperty ctermfg=223 guifg=#E1BEE7
	hi CocSymbolColor ctermfg=5 guifg=#FFEBEE
	hi CocSymbolFile  ctermfg=4 guifg=#F3E5F5
	hi CocSymbolEvent ctermfg=223 guifg=#FFF3E0
	hi CocSymbolTypeParameter ctermfg=223 guifg=#26C6DA
	hi CocSymbolConstructor ctermfg=223 guifg=#4DD0E1
	hi CocSymbolSnippet ctermfg=6 guifg=#9575CD
	hi CocSymbolBoolean ctermfg=4 guifg=#FFAB91
	hi CocSymbolNamespace ctermfg=4 guifg=#FFAB91
	hi CocSymbolString ctermfg=2 guifg=#F44336
	hi CocSymbolEnumMember ctermfg=223 guifg=#AB47BC
	hi CocHighlightText guibg=#696969
	]])
    end,
  },
  {
    "mlaursen/vim-react-snippets",
    config = function()
      require("vim-react-snippets").setup({})
    end,
  },
  { "rafamadriz/friendly-snippets",                        lazy = true },
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
      end, vim.list_extend(opts.ensure_installedor or {}, vim.g.mason_ensure_installed or {}) or {})
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
  {
    "folke/snacks.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>,",       false },
      { "<leader>/",       false },
      { "<leader>:",       false },
      { "<leader><space>", false },
      { "<leader>n",       false },
      -- find
      { "<leader>fb",      false },
      { "<leader>fB",      false },
      { "<leader>fc",      false },
      { "<leader>ff",      false },
      { "<leader>fF",      false },
      { "<leader>fg",      false },
      { "<leader>fr",      false },
      { "<leader>fR",      false },
      { "<leader>fp",      false },
      -- git
      { "<leader>gd",      false },
      { "<leader>gD",      false },
      { "<leader>gs",      false },
      { "<leader>gS",      false },
      { "<leader>gi",      false },
      { "<leader>gI",      false },
      { "<leader>gp",      false },
      { "<leader>gP",      false },
      -- Grep
      { "<leader>sb",      false },
      { "<leader>sB",      false },
      { "<leader>sg",      false },
      { "<leader>sG",      false },
      { "<leader>sp",      false },
      { "<leader>sw",      false },
      { "<leader>sW",      false },
      -- search
      { '<leader>s"',      false },
      { '<leader>s/',      false },
      { "<leader>sa",      false },
      { "<leader>sc",      false },
      { "<leader>sC",      false },
      { "<leader>sd",      false },
      { "<leader>sD",      false },
      { "<leader>sh",      false },
      { "<leader>sH",      false },
      { "<leader>si",      false },
      { "<leader>sj",      false },
      { "<leader>sk",      false },
      { "<leader>sl",      false },
      { "<leader>sM",      false },
      { "<leader>sm",      false },
      { "<leader>sR",      false },
      { "<leader>sq",      false },
      { "<leader>su",      false },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = not vim.g.ai_cmp and "<M-l>" or false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  { "folke/trouble.nvim",        enabled = false },
  { "akinsho/bufferline.nvim",   enabled = false },
  { "nvim-lualine/lualine.nvim", enabled = false },
  { "MagicDuck/grug-far.nvim",   enabled = false },
  { "folke/todo-comments.nvim",  enabled = false },
  { "neovim/nvim-lspconfig",     enabled = false },
  { "hrsh7th/nvim-cmp",          enabled = false },
  { "hrsh7th/cmp-nvim-lsp",      enabled = false },
  { "saghen/blink.cmp",          enabled = false },
  { "stevearc/conform.nvim",     enabled = false },
  { "mfussenegger/nvim-lint",    enabled = false },
  { "folke/noice.nvim",          enabled = false },
  { "folke/lazydev.nvim",        enabled = false },
  { "lewis6991/gitsigns.nvim",   enabled = false },
  { "catppuccin/nvim",           enabled = false },
  { "folke/tokyonight.nvim",     enabled = false },
  { "zeioth/garbage-day.nvim",   enabled = false },
  { "uga-rosa/translate.nvim",   enabled = false },
}
