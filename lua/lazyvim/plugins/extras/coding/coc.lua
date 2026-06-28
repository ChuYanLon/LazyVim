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

local function renderUi()
  local icons = LazyVim.config.icons
  local diag = icons.diagnostics
  vim.g.coc_status_error_sign = diag.Error
  vim.g.coc_status_warning_sign = diag.Warn
  vim.g.coc_status_info_sign = diag.Info
  vim.g.coc_status_hint_sign = diag.Hint
  vim.g.coc_notify_error_icon = diag.Error
  vim.g.coc_notify_warning_icon = diag.Warn
  vim.g.coc_notify_info_icon = diag.Info
  local kind_labels = {
    text = " " .. icons.kinds.Text .. " ",
    method = " " .. icons.kinds.Method .. " ",
    ["function"] = " " .. icons.kinds.Function .. " ",
    constructor = " " .. icons.kinds.Constructor .. " ",
    field = " " .. icons.kinds.Field .. " ",
    variable = " " .. icons.kinds.Variable .. " ",
    class = " " .. icons.kinds.Class .. " ",
    interface = " " .. icons.kinds.Interface .. " ",
    module = " " .. icons.kinds.Module .. " ",
    property = " " .. icons.kinds.Property .. " ",
    unit = " " .. icons.kinds.Unit .. " ",
    value = " " .. icons.kinds.Value .. " ",
    enum = " " .. icons.kinds.Enum .. " ",
    keyword = " " .. icons.kinds.Keyword .. " ",
    snippet = " " .. icons.kinds.Snippet .. " ",
    color = " " .. icons.kinds.Color .. " ",
    file = " " .. icons.kinds.File .. " ",
    reference = " " .. icons.kinds.Reference .. " ",
    folder = " " .. icons.kinds.Folder .. " ",
    enumMember = " " .. icons.kinds.EnumMember .. " ",
    constant = " " .. icons.kinds.Constant .. " ",
    struct = " " .. icons.kinds.Struct .. " ",
    event = " " .. icons.kinds.Event .. " ",
    operator = " " .. icons.kinds.Operator .. " ",
    typeParameter = " " .. icons.kinds.TypeParameter .. " ",
    ["default"] = " 󰠱 ",
  }
  local config = {
    diagnostic = {
      enable = true,
      virtualText = true,
      virtualTextCurrentLineOnly = false,
      floatSource = true,
      floatPrefix = "●",
      signText = { Error = diag.Error, Warning = diag.Warn, Info = diag.Info, Hint = diag.Hint },
      signPriority = 10,
      refreshAfterInsertMode = true,
      checkCurrentLine = true,
    },
    suggest = {
      noselect = false,
      maxCompleteItemCount = 200,
      detailMaxWidth = 80,
      floatEnable = true,
      filterDuplicates = true,
      removeDuplicateItems = true,
      formatItems = { "kind", "abbr", "menu", "shortcut" },
      completionItemKindLabels = kind_labels,
      pumHeight = vim.o.pumheight,
    },
    signature = { enable = true },
    hover = { border = "rounded" },
    floating = { border = "rounded" },
    codeLens = { enable = true },
    inlayHint = { enable = true },
    tree = { renderChildren = true, openedIcon = "", closedIcon = "" },
  }
  vim.g.coc_user_config = vim.tbl_deep_extend("force", vim.g.coc_user_config or {}, config)
  local sign = vim.fn.sign_define
  sign("DiagnosticSignError", { text = diag.Error, texthl = "DiagnosticSignError" })
  sign("DiagnosticSignWarn", { text = diag.Warn, texthl = "DiagnosticSignWarn" })
  sign("DiagnosticSignInfo", { text = diag.Info, texthl = "DiagnosticSignInfo" })
  sign("DiagnosticSignHint", { text = diag.Hint, texthl = "DiagnosticSignHint" })
  local hl = vim.api.nvim_set_hl
  local function link(name, linkto)
    hl(0, name, { link = linkto })
  end
  link("CocFloating", "NormalFloat")
  link("CocFloatBorder", "FloatBorder")
  link("CocFloatActive", "NormalFloat")
  link("CocMenuSel", "PmenuSel")
  link("CocPumSearch", "PmenuSel")
  link("CocPumDetail", "Comment")
  link("CocHighlightText", "Visual")
  link("CocCodeLens", "Comment")
  link("CocInlayHint", "Comment")
  link("CocBold", "Bold")
  link("CocItalic", "Italic")
  link("CocUnderline", "Underlined")
  link("CocMarkdownLink", "markdownLinkText")
  link("CocMarkdownHeader", "markdownH1")
  link("CocMarkdownCode", "markdownCode")
  link("CocErrorHighlight", "DiagnosticUndercurlError")
  link("CocWarningHighlight", "DiagnosticUndercurlWarn")
  link("CocInfoHighlight", "DiagnosticUndercurlInfo")
  link("CocHintHighlight", "DiagnosticUndercurlHint")
  link("CocDeprecatedHighlight", "DiagnosticDeprecated")
  link("CocUnusedHighlight", "DiagnosticUnnecessary")
  link("CocErrorVirtualText", "DiagnosticVirtualTextError")
  link("CocWarningVirtualText", "DiagnosticVirtualTextWarn")
  link("CocInfoVirtualText", "DiagnosticVirtualTextInfo")
  link("CocHintVirtualText", "DiagnosticVirtualTextHint")
  link("CocErrorSign", "DiagnosticSignError")
  link("CocWarningSign", "DiagnosticSignWarn")
  link("CocInfoSign", "DiagnosticSignInfo")
  link("CocHintSign", "DiagnosticSignHint")
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

local function renderKeys()
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
    { 'n', '<leader>cr', '<Plug>(coc-codeaction-refactor)',                                                          { desc = 'refactor' } },
    { 'x', '<leader>cr', '<Plug>(coc-codeaction-refactor-selected)',                                                 { desc = 'refactor' } },
    { 'n', '<leader>cf', ':Format<CR>',                                                                              { desc = 'format' } },
    { 'x', '<leader>cf', '<Plug>(coc-format-selected)',                                                              { desc = 'format' } },
    { 'n', '<leader>ca', '<Plug>(coc-codeaction-line)',                                                              { desc = 'action' } },
    { 'x', '<leader>ca', '<Plug>(coc-codeaction-selected)',                                                          { desc = 'action' } },
    { 'n', '<leader>cA', '<Plug>(coc-codeaction-source)',                                                            { desc = 'sourceAction' } },
    { 'n', '<leader>cl', '<Plug>(coc-codelens-action)',                                                              { desc = 'codelensAction' } },
    { 'n', '<leader>cn', '<Plug>(coc-rename)',                                                                       { desc = 'rename' } },
    { 'n', '<space>cs',  ':<C-u>CocOutline<CR>',                                                                     { desc = 'outline' } },
    { 'n', '<leader>cq', '<Plug>(coc-fix-current)',                                                                  { desc = 'fix' } },
    { 'n', '<space>xx',  ':<C-u>CocDiagnostics<CR>',                                                                 { desc = 'diagnostics' } },
    { 'n', '<space>xs',  ':<C-u>CocList diagnostics<CR>',                                                            { desc = 'all diagnostics' } },
    { 'n', '[d',         '<Plug>(coc-diagnostic-prev)',                                                              { desc = 'previous diagnostic' } },
    { 'n', ']d',         '<Plug>(coc-diagnostic-next)',                                                              { desc = 'next diagnostic' } },
    { 'n', '<leader>cm', ':<C-u>CocCommand loader.open<CR>',                                                               { desc = 'commands' } },
    { 'n', '<C-n>',      'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-n>"',                                   { expr = true, desc = 'Scroll down in Coc float' } },
    { 'n', '<C-p>',      'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-p>"',                                   { expr = true, desc = 'Scroll up in Coc float' } },
    { 'i', '<C-n>',      'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',                     { expr = true, desc = 'Insert mode: Scroll down float' } },
    { 'i', '<C-p>',      'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',                      { expr = true, desc = 'Insert mode: Scroll up float' } },
    { 'v', '<C-n>',      'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-n>"',                                   { expr = true, desc = 'Visual mode: Scroll down float' } },
    { 'v', '<C-p>',      'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-p>"',                                   { expr = true, desc = 'Visual mode: Scroll up float' } },
    { 'n', 'mm',         '<Plug>(coc-translator-p)',                                                                 { desc = 'translate' } },
    { 'v', 'mm',         '<Plug>(coc-translator-pv)',                                                                { desc = 'translate' } },
  })
end

return {
  { "neovim/nvim-lspconfig",  enabled = false },
  { "hrsh7th/nvim-cmp",       enabled = false },
  { "hrsh7th/cmp-nvim-lsp",   enabled = false },
  { "saghen/blink.cmp",       enabled = false },
  { "stevearc/conform.nvim",  enabled = false },
  { "mfussenegger/nvim-lint", enabled = false },
  { "catppuccin/nvim",        enabled = false },
  { "mason-org/mason.nvim",   enabled = false },
  { "folke/lazydev.nvim",   enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = LazyVim.config.icons.diagnostics
      for i, item in ipairs(opts.sections.lualine_c) do
        if type(item) == "table" and item[1] == "diagnostics" then
          opts.sections.lualine_c[i] = {
            function(self)
              local info = vim.b.coc_diagnostic_info
              if not info then
                return ""
              end
              local parts = {}
              if info.error and info.error > 0 then
                table.insert(parts, LazyVim.lualine.format(self, icons.Error .. info.error, "DiagnosticError"))
              end
              if info.warning and info.warning > 0 then
                table.insert(parts, LazyVim.lualine.format(self, icons.Warn .. info.warning, "DiagnosticWarn"))
              end
              if info.information and info.information > 0 then
                table.insert(parts, LazyVim.lualine.format(self, icons.Info .. info.information, "DiagnosticInfo"))
              end
              if info.hint and info.hint > 0 then
                table.insert(parts, LazyVim.lualine.format(self, icons.Hint .. info.hint, "DiagnosticHint"))
              end
              return table.concat(parts, " ")
            end,
            cond = function()
              local info = vim.b.coc_diagnostic_info
              return info ~= nil
                  and ((info.error or 0) > 0
                    or (info.warning or 0) > 0
                    or (info.information or 0) > 0
                    or (info.hint or 0) > 0)
            end,
          }
          break
        end
      end
      table.insert(opts.sections.lualine_x, {
        function()
          local status = vim.g.coc_status
          if type(status) ~= "string" then
            return ""
          end
          status = vim.trim(status)
          if status == "" then
            return ""
          end
          return " " .. status:gsub("%%", "%%%%"):gsub("[<>]", { ["<"] = "＜", [">"] = "＞" })
        end,
        cond = function()
          local status = vim.g.coc_status
          return type(status) == "string" and vim.trim(status) ~= ""
        end,
      })
      -- coc 状态更新时刷新 lualine
      vim.api.nvim_create_autocmd("User", {
        pattern = "CocStatusChange",
        group = vim.api.nvim_create_augroup("lazyvim_coc_lualine", { clear = true }),
        callback = function()
          pcall(require("lualine").refresh)
        end,
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options.diagnostics = "coc"
    end,
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.lsp = nil
      opts.routes = opts.routes or {}
      vim.list_extend(opts.routes, {
        {
          filter = { event = "cmdline", find = "ZFVimIME" },
          opts = { skip = true },
        },
        {
          filter = { event = "cmdline", find = "Omni" },
          opts = { skip = true },
        },
        {
          filter = { event = "cmdline", find = "coc#on_enter" },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", find = "coc#on_enter" },
          opts = { skip = true },
        },
        {
          filter = { find = "coc#on_enter" },
          opts = { skip = true },
        },
      })
    end,
  },
  {
    "folke/snacks.nvim",
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
      renderUi()
      renderKeys()
    end,
  },
}
