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
  { "neovim/nvim-lspconfig",  optional = true, enabled = false },
  { "hrsh7th/nvim-cmp",       optional = true, enabled = false },
  { "hrsh7th/cmp-nvim-lsp",   optional = true, enabled = false },
  { "saghen/blink.cmp",       optional = true, enabled = false },
  { "stevearc/conform.nvim",  optional = true, enabled = false },
  { "mfussenegger/nvim-lint", optional = true, enabled = false },
  { "catppuccin/nvim",        optional = true, enabled = false },
  { "mason-org/mason.nvim",   optional = true, enabled = false },
  { "folke/lazydev.nvim",     optional = true, enabled = false },
  { "folke/noice.nvim",       optional = true, enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
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
    optional = true,
    opts = function(_, opts)
      opts.options.diagnostics = "coc"
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      preset = "helix",
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>p", desc = "package", icon = "󰏖 " },
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
      vim.keymap.set("n", "<leader>cl", ":<C-u>CocInfo<Cr>", { silent = true, nowait = true })
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
        -- { 'n', '<leader>cl', '<Plug>(coc-codelens-action)',                                                              { desc = 'codelensAction' } },
        { 'n', '<leader>cn', '<Plug>(coc-rename)',                                                                       { desc = 'rename' } },
        { 'n', '<space>cs',  ':<C-u>CocOutline<CR>',                                                                     { desc = 'outline' } },
        { 'n', '<leader>cq', '<Plug>(coc-fix-current)',                                                                  { desc = 'fix' } },
        { 'n', '<space>xx',  ':<C-u>CocDiagnostics<CR>',                                                                 { desc = 'diagnostics' } },
        { 'n', '<space>xs',  ':<C-u>CocList diagnostics<CR>',                                                            { desc = 'all diagnostics' } },
        { 'n', '[d',         '<Plug>(coc-diagnostic-prev)',                                                              { desc = 'previous diagnostic' } },
        { 'n', ']d',         '<Plug>(coc-diagnostic-next)',                                                              { desc = 'next diagnostic' } },
        { 'n', '<leader>cm', ':<C-u>CocCommand loader.open<CR>',                                                         { desc = 'commands' } },
        { 'n', '<C-n>',      'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-n>"',                                   { expr = true, desc = 'Scroll down in Coc float' } },
        { 'n', '<C-p>',      'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-p>"',                                   { expr = true, desc = 'Scroll up in Coc float' } },
        { 'i', '<C-n>',      'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',                     { expr = true, desc = 'Insert mode: Scroll down float' } },
        { 'i', '<C-p>',      'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',                      { expr = true, desc = 'Insert mode: Scroll up float' } },
        { 'v', '<C-n>',      'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-n>"',                                   { expr = true, desc = 'Visual mode: Scroll down float' } },
        { 'v', '<C-p>',      'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-p>"',                                   { expr = true, desc = 'Visual mode: Scroll up float' } },
        { 'n', 'mm',         '<Plug>(coc-translator-p)',                                                                 { desc = 'translate' } },
        { 'v', 'mm',         '<Plug>(coc-translator-pv)',                                                                { desc = 'translate' } },
        { 'n', '<leader>pc', ':<C-u>CocList commands<CR>',                                                               { desc = 'commands' } },
        { 'n', '<leader>pl', ':<C-u>CocList<CR>',                                                                        { desc = 'List' } },
        { 'n', '<leader>ps', ':<C-u>CocList services<CR>',                                                               { desc = 'services' } },
        { 'n', '<leader>pe', ':<C-u>CocList extensions<CR>',                                                             { desc = 'extensions' } },
        { 'n', '<leader>pr', ':CocRestart<CR>',                                                                          { desc = 'restart' } },
      })
    end,
  },
}
