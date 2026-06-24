return {
  {
    "saghen/blink.cmp",
    enabled = false,
    optional = true,
  },
  {
    "neovim/nvim-lspconfig",
    enabled = false,
    optional = true,
  },
  {
    "mason-org/mason.nvim",
    enabled = false,
    optional = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = LazyVim.config.icons.diagnostics
      for i, item in ipairs(opts.sections.lualine_c) do
        if type(item) == "table" and item[1] == "diagnostics" then
          opts.sections.lualine_c[i] = {
            function()
              local info = vim.b.coc_diagnostic_info
              if not info then
                return ""
              end
              local parts = {}
              if info.error and info.error > 0 then
                table.insert(parts, icons.Error .. info.error)
              end
              if info.warning and info.warning > 0 then
                table.insert(parts, icons.Warn .. info.warning)
              end
              if info.information and info.information > 0 then
                table.insert(parts, icons.Info .. info.information)
              end
              if info.hint and info.hint > 0 then
                table.insert(parts, icons.Hint .. info.hint)
              end
              return table.concat(parts, " ")
            end,
            cond = function()
              local info = vim.b.coc_diagnostic_info
              return info ~= nil
                and ((info.error or 0) > 0 or (info.warning or 0) > 0)
            end,
          }
          break
        end
      end
      table.insert(opts.sections.lualine_x, {
        function()
          local ok, status = pcall(vim.fn["coc#status"])
          return ok and status or ""
        end,
        cond = function()
          local ok, status = pcall(vim.fn["coc#status"])
          return ok and status ~= ""
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
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.default_format_opts.lsp_format = "never"
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
    event = "VeryLazy",
    config = function()
      vim.g.coc_global_extensions = {
        "coc-json",
        "coc-tsserver",
        "coc-vscode-loader",
      }
      vim.g.coc_loader_global_extensions = {}

      vim.g.coc_status_error_sign = LazyVim.config.icons.diagnostics.Error
      vim.g.coc_status_warning_sign = LazyVim.config.icons.diagnostics.Warn
      vim.g.coc_borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
      vim.g.coc_notify_error_icon = LazyVim.config.icons.diagnostics.Error
      vim.g.coc_notify_warning_icon = LazyVim.config.icons.diagnostics.Warn
      vim.g.coc_notify_info_icon = LazyVim.config.icons.diagnostics.Info

      vim.fn["coc#config"]({
        ["diagnostic.level"] = "hint",
        ["diagnostic.locationlist"] = true,
        ["diagnostic.virtualText"] = true,
      })

      local diag_icons = LazyVim.config.icons.diagnostics
      vim.fn["coc#config"]({
        ["diagnostic.sign"] = {
          text = {
            ["error"] = diag_icons.Error,
            ["warning"] = diag_icons.Warn,
            ["information"] = diag_icons.Info,
            ["hint"] = diag_icons.Hint,
          },
        },
      })

      -- LSP 导航
      vim.keymap.set("n", "gd", function()
        vim.fn.CocAction("jumpDefinition")
      end, { desc = "Goto Definition" })
      vim.keymap.set("n", "gr", function()
        vim.fn.CocAction("jumpReferences")
      end, { desc = "References" })
      vim.keymap.set("n", "gI", function()
        vim.fn.CocAction("jumpImplementation")
      end, { desc = "Goto Implementation" })
      vim.keymap.set("n", "gy", function()
        vim.fn.CocAction("jumpTypeDefinition")
      end, { desc = "Goto Type Definition" })
      vim.keymap.set("n", "gD", function()
        vim.fn.CocAction("jumpDeclaration")
      end, { desc = "Goto Declaration" })
      vim.keymap.set("n", "K", function()
        vim.fn.CocActionAsync("doHover")
      end, { desc = "Hover" })
      vim.keymap.set("n", "gK", function()
        vim.fn.CocActionAsync("showSignatureHelp")
      end, { desc = "Signature Help" })
      vim.keymap.set("i", "<c-k>", function()
        vim.fn.CocActionAsync("showSignatureHelp")
      end, { desc = "Signature Help" })

      -- 代码操作（4 个 codeAction 变体）
      vim.keymap.set({ "n", "x" }, "<leader>ca", function()
        vim.fn.CocAction("codeAction")
      end, { desc = "Code Action" })
      vim.keymap.set("n", "<leader>cA", function()
        vim.fn.CocAction("codeAction", nil, "source")
      end, { desc = "Source Action" })
      vim.keymap.set("n", "<leader>cl", function()
        vim.fn.CocAction("codeAction", nil, nil, true)
      end, { desc = "Line Action" })
      vim.keymap.set({ "n", "x" }, "<leader>cr", function()
        vim.fn.CocAction("codeAction", nil, "refactor")
      end, { desc = "Refactor" })
      vim.keymap.set("n", "<leader>rn", function()
        vim.fn.CocAction("rename")
      end, { desc = "Rename" })
      vim.keymap.set("n", "<leader>ci", "<Cmd>CocInfo<CR>", { desc = "Coc Info" })
      vim.keymap.set("n", "<leader>cR", "<Cmd>CocCommand workspace.renameCurrentFile<CR>", { desc = "Rename File" })
      vim.keymap.set("n", "<leader>co", function()
        vim.fn.CocAction("runCommand", "editor.action.organizeImport")
      end, { desc = "Organize Imports" })
      vim.keymap.set({ "n", "x" }, "<leader>cc", function()
        vim.fn.CocAction("codeLensAction")
      end, { desc = "CodeLens Action" })
      vim.keymap.set("n", "<leader>cC", "<Cmd>CocCommand document.toggleCodeLens<CR>", { desc = "Toggle CodeLens" })
      vim.keymap.set("n", "<leader>cm", "<Cmd>CocCommand loader.open<CR>", { desc = "Coc Extensions" })

      -- 诊断导航
      vim.keymap.set("n", "]d", function()
        vim.fn.CocAction("diagnosticNext")
      end, { desc = "Next Diagnostic" })
      vim.keymap.set("n", "[d", function()
        vim.fn.CocAction("diagnosticPrevious")
      end, { desc = "Prev Diagnostic" })
      vim.keymap.set("n", "]e", function()
        vim.fn.CocAction("diagnosticNext")
      end, { desc = "Next Error" })
      vim.keymap.set("n", "[e", function()
        vim.fn.CocAction("diagnosticPrevious")
      end, { desc = "Prev Error" })
      vim.keymap.set("n", "]w", function()
        vim.fn.CocAction("diagnosticNext")
      end, { desc = "Next Warning" })
      vim.keymap.set("n", "[w", function()
        vim.fn.CocAction("diagnosticPrevious")
      end, { desc = "Prev Warning" })
      vim.keymap.set("n", "<leader>cd", function()
        vim.fn.CocActionAsync("doHover")
      end, { desc = "Line Diagnostics" })
      vim.keymap.set("n", "<leader>ud", function()
        vim.fn.CocAction("diagnosticToggle")
      end, { desc = "Toggle Diagnostics" })

      -- 格式化
      vim.keymap.set({ "n", "x" }, "<leader>cf", function()
        vim.fn.CocAction("format")
      end, { desc = "Format" })

      -- 补全
      vim.keymap.set("i", "<Tab>", function()
        if vim.fn["coc#pum#visible"]() == 1 then
          return vim.fn["coc#pum#next"](1)
        end
        if vim.fn["coc#expandableOrJumpable"]() == 1 then
          return vim.fn["coc#expandOrJump"]()
        end
        local col = vim.fn.col(".") - 1
        if col > 0 and vim.fn.getline("."):sub(col, col):match("%s") then
          return "<Tab>"
        end
        return vim.fn["coc#refresh"]()
      end, { expr = true, desc = "Tab Complete" })

      vim.keymap.set("i", "<S-Tab>", function()
        if vim.fn["coc#pum#visible"]() == 1 then
          return vim.fn["coc#pum#prev"](1)
        end
        return "<C-h>"
      end, { expr = true, desc = "Prev Completion" })

      vim.keymap.set("i", "<CR>", function()
        if vim.fn["coc#pum#visible"]() == 1 then
          return vim.fn["coc#pum#confirm"]()
        end
        return "<C-g>u<CR><c-r>=coc#on_enter()<CR>"
      end, { expr = true, desc = "Confirm Completion" })

      vim.keymap.set("i", "<C-space>", "coc#refresh()", { expr = true, desc = "Trigger Completion" })

      -- 浮动窗口滚动
      vim.keymap.set({ "i", "n", "s" }, "<c-f>", function()
        if vim.fn["coc#float#has_scroll"]() == 1 then
          vim.fn["coc#float#scroll"](1)
          return ""
        end
        return "<c-f>"
      end, { expr = true, desc = "Scroll Forward" })

      vim.keymap.set({ "i", "n", "s" }, "<c-b>", function()
        if vim.fn["coc#float#has_scroll"]() == 1 then
          vim.fn["coc#float#scroll"](0)
          return ""
        end
        return "<c-b>"
      end, { expr = true, desc = "Scroll Backward" })

      -- Escape
      vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
        vim.cmd("noh")
        return "<esc>"
      end, { expr = true, desc = "Escape and Clear hlsearch" })

      -- Coc 新增
      vim.keymap.set("n", "]g", function()
        vim.fn.CocAction("diagnosticNext")
      end, { desc = "Next Diagnostic" })
      vim.keymap.set("n", "[g", function()
        vim.fn.CocAction("diagnosticPrevious")
      end, { desc = "Prev Diagnostic" })
      vim.keymap.set("n", "g.", function()
        vim.fn.CocAction("doQuickfix")
      end, { desc = "Quickfix" })
      vim.keymap.set("n", "<leader>cs", "<Cmd>CocOutline<CR>", { desc = "Coc Outline" })
      vim.keymap.set("n", "<leader>cS", "<Cmd>CocList outline<CR>", { desc = "Coc List Outline" })
      vim.keymap.set("n", "<leader>xl", "<Cmd>CocList location<CR>", { desc = "Location List" })
      vim.keymap.set("n", "<leader>xq", "<Cmd>CocList quickfix<CR>", { desc = "Quickfix List" })
    end,
  },
}
