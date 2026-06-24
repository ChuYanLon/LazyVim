# Coc.nvim 完全接管 LazyVim — 最终方案

## 核心原则

**不改 LazyVim 核心文件。** 所有适配在 `coding.coc` extra 中用 lazy.nvim spec 覆盖机制完成。去掉 `coding.coc` 的 import 即完全恢复原状。

## 禁用插件

启用 `coding.coc` 后，以下插件被禁用：

| 插件 | 原因 |
|------|------|
| `blink.cmp` | 补全引擎冲突，coc 自带 |
| `nvim-lspconfig` | LSP 管理冲突，coc 自带 |
| `mason.nvim` | 工具安装冲突，`coc-vscode-loader` 替代 |

## 按键映射完整对照

### LSP 导航

| 按键 | LazyVim 原始调用 | Coc Action |
|------|-----------------|------------|
| `gd` | `vim.lsp.buf.definition` | `CocAction('jumpDefinition')` |
| `gr` | `vim.lsp.buf.references` | `CocAction('jumpReferences')` |
| `gI` | `vim.lsp.buf.implementation` | `CocAction('jumpImplementation')` |
| `gy` | `vim.lsp.buf.type_definition` | `CocAction('jumpTypeDefinition')` |
| `gD` | `vim.lsp.buf.declaration` | `CocAction('jumpDeclaration')` |
| `K` | `vim.lsp.buf.hover()` | `CocActionAsync('doHover')` |
| `gK` | `vim.lsp.buf.signature_help()` | `CocActionAsync('showSignatureHelp')` |
| `<c-k>` (i) | `vim.lsp.buf.signature_help()` | `CocActionAsync('showSignatureHelp')` |

### 代码操作

| 按键 | mode | LazyVim 原始调用 | Coc Action |
|------|------|-----------------|------------|
| `<leader>ca` | n,x | `vim.lsp.buf.code_action` | `CocAction('codeAction')` 通用 |
| `<leader>cA` | n | `LazyVim.lsp.action.source` | `CocAction('codeAction', nil, 'source')` 仅 source |
| `<leader>cl` | n | `Snacks.picker.lsp_config()` | `CocAction('codeAction', nil, nil, v:true)` 仅当前行 |
| `<leader>cr` | n,x | `vim.lsp.buf.rename` | `CocAction('codeAction', nil, 'refactor')` 仅重构 |
| `<leader>rn` | n | — | `CocAction('rename')` 重命名（原 cr） |
| `<leader>ci` | n | — | `:CocInfo`（原 cl） |
| `<leader>cR` | n | `Snacks.rename.rename_file()` | `:CocCommand workspace.renameCurrentFile` |
| `<leader>co` | n | `LazyVim.lsp.action["source.organizeImports"]` | `CocAction('runCommand', 'editor.action.organizeImport')` |
| `<leader>cc` | n,x | `vim.lsp.codelens.run` | `CocAction('codeLensAction')` |
| `<leader>cC` | n | `vim.lsp.codelens.refresh` | `:CocCommand document.toggleCodeLens` |
| `<leader>cm` | n | Mason 打开 | `:CocCommand loader.open` |

### 诊断导航

| 按键 | LazyVim 原始调用 | Coc Action |
|------|-----------------|------------|
| `]d` | `vim.diagnostic.jump({ next })` | `CocAction('diagnosticNext')` |
| `[d` | `vim.diagnostic.jump({ prev })` | `CocAction('diagnosticPrevious')` |
| `]e` | `vim.diagnostic.jump({ next, ERROR })` | `CocAction('diagnosticNext')` |
| `[e` | `vim.diagnostic.jump({ prev, ERROR })` | `CocAction('diagnosticPrevious')` |
| `]w` | `vim.diagnostic.jump({ next, WARN })` | `CocAction('diagnosticNext')` |
| `[w` | `vim.diagnostic.jump({ prev, WARN })` | `CocAction('diagnosticPrevious')` |
| `<leader>cd` | `vim.diagnostic.open_float` | `CocActionAsync('doHover')` |
| `<leader>ud` | `Snacks.toggle.diagnostics()` | 保留（coc 也走 `vim.diagnostic`） |
| `<leader>xx` | `Trouble diagnostics toggle` | 保留 |
| `<leader>xX` | `Trouble diagnostics filter.buf=0` | 保留 |

### 格式化

| 按键 | LazyVim 原始调用 | Coc Action |
|------|-----------------|------------|
| `<leader>cf` | `LazyVim.format({ force = true })` | `CocAction('format')` |
| `<leader>cF` | `conform.format({ formatters = {"injected"} })` | 保留 |
| `<leader>uf` | autoformat toggle | 保留 |
| `<leader>uF` | buffer autoformat toggle | 保留 |

### 补全

| 按键 | mode | Coc 映射 |
|------|------|----------|
| `<Tab>` | i | `coc#pum#visible() ? coc#pum#next(1) : coc#expandableOrJumpable() ? ... : coc#refresh()` |
| `<S-Tab>` | i | `coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"` |
| `<CR>` | i | `coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"` |
| `<C-space>` | i | `coc#refresh()` |
| `<C-y>` | i | coc 默认确认 |
| `<C-e>` | i | coc 默认取消 |
| `<C-n>` / `<C-p>` | i | coc 默认上下选择 |
| `<C-f>` / `<C-b>` | i,n,s | `coc#float#scroll(1/0)` 浮动窗口滚动 |
| `<Esc>` | i,n,s | 清除搜索（移除 cmp snippet_stop） |

### Coc 新增键

| 按键 | mode | 功能 |
|------|------|------|
| `]g` | n | 下一个诊断（coc 社区习惯） |
| `[g` | n | 上一个诊断（coc 社区习惯） |
| `g.` | n | 当前行 quickfix |
| `<leader>cs` | n | `:CocOutline` 大纲树 |
| `<leader>cS` | n | `:CocList outline` 搜索大纲 |
| `<leader>xl` | n | `:CocList location` |
| `<leader>xq` | n | `:CocList quickfix` |

## UI 组件覆盖

### Lualine

| 位置 | LazyVim 默认 | Coc 替换 |
|------|-------------|----------|
| `lualine_c` diagnostics | `vim.diagnostic` 计数 | `coc#status()` 字符串 |
| `lualine_x` cmp_source | `require("cmp").core.sources` | 移除 |

### Bufferline

| 选项 | LazyVim 默认 | Coc 替换 |
|------|-------------|----------|
| `diagnostics` | `"nvim_lsp"` | `"coc"` |

### Noice

| 选项 | LazyVim 默认 | Coc 替换 |
|------|-------------|----------|
| `lsp.override` | 拦截 `vim.lsp.util.*`, `cmp.entry.*` | `nil`（删除） |

## 配置覆盖

| 选项 | 原始 | Coc 调整 |
|------|------|----------|
| `root_spec` | `{ "lsp", { ".git", "lua" }, "cwd" }` | 去掉 `"lsp"` |
| `conform default_format_opts.lsp_format` | `"fallback"` | `"never"` |
| `formatexpr` | `v:lua.LazyVim.format.formatexpr()` | 保留（coc 支持 `formatexpr`） |
| `completeopt` | `"menu,menuone,noselect"` | 保留（兼容） |

## 不可用的 LazyVim 功能

| 功能 | 原因 | 替代 |
|------|------|------|
| `]]` `[[` `<a-n>` `<a-p>` 词导航（Snacks.words） | 依赖 `vim.lsp` documentHighlight | 无 |
| Trouble symbols 模式（`<leader>cs` 已改为 CocOutline） | 依赖 `vim.lsp` 获取符号 | `:CocList outline` |
| Trouble LSP 模式（`<leader>cS` 已改为 CocList outline） | 依赖 `vim.lsp` | `:CocList` 相关源 |
| aerial.nvim LSP 后端 | 依赖 `vim.lsp` | 可启用 treesitter 后端 |
| navic.nvim（lualine 面包屑） | 依赖 `vim.lsp` | 移除 |
| telescope/fzf/snacks 的 LSP pickers | 依赖 `vim.lsp` + nvim-lspconfig | 已用 gd/gr 等直接跳转 |
| inc-rename.nvim | 依赖 `vim.lsp` | `<leader>cr` 改为 `CocAction('rename')` |
| Snacks.picker.lsp_config() | 依赖 nvim-lspconfig | `:CocInfo` |

## 兼容功能（无需修改）

gitsigns, flash.nvim, which-key, nvim-treesitter-textobjects, todo-comments, conform（非 LSP 格式化）, nvim-lint, dial, mini.surround, mini.ai, mini.pairs, refactoring.nvim, yanky, lazygit, persistence, terminal, scratch, Snacks toggle（非 LSP）

## 语言 Extra

~45 个语言 extra 声明了 `nvim-lspconfig` / `mason.nvim` 依赖，懒加载无法匹配时会自动跳过。对应语言服务器需通过 `coc-vscode-loader` TUI 或 `g:coc_loader_global_extensions` 安装 VS Code 扩展替代。

## Extra 代码

```lua
return {
  -- 禁用冲突插件
  { "saghen/blink.cmp", enabled = false, optional = true },
  { "neovim/nvim-lspconfig", enabled = false, optional = true },
  { "mason-org/mason.nvim", enabled = false, optional = true },

  -- Lualine: diagnostics → coc#status(), 移除 cmp_source
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      for i, item in ipairs(opts.sections.lualine_c) do
        if type(item) == "table" and item[1] == "diagnostics" then
          opts.sections.lualine_c[i] = {
            function() return vim.fn["coc#status"]() end,
            cond = function() return vim.fn["coc#status"]() ~= "" end,
          }
          break
        end
      end
    end,
  },

  -- Bufferline: diagnostics 来源改为 coc
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options.diagnostics = "coc"
    end,
  },

  -- Noice: 移除 LSP 拦截（coc 有自己的 UI）
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.lsp = nil
    end,
  },

  -- Conform: 不 fallback 到 LSP
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.default_format_opts.lsp_format = "never"
    end,
  },

  -- Root spec: 去掉 lsp 检测器
  {
    "snacks.nvim",
    opts = function(_, opts)
      opts.root_spec = vim.tbl_filter(function(v)
        return v ~= "lsp"
      end, opts.root_spec or { { ".git", "lua" }, "cwd" })
    end,
  },

  -- Coc.nvim
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

      -- LSP 导航
      vim.keymap.set("n", "gd", function() vim.fn.CocAction("jumpDefinition") end, { desc = "Goto Definition" })
      vim.keymap.set("n", "gr", function() vim.fn.CocAction("jumpReferences") end, { desc = "References" })
      vim.keymap.set("n", "gI", function() vim.fn.CocAction("jumpImplementation") end, { desc = "Goto Implementation" })
      vim.keymap.set("n", "gy", function() vim.fn.CocAction("jumpTypeDefinition") end, { desc = "Goto Type Definition" })
      vim.keymap.set("n", "gD", function() vim.fn.CocAction("jumpDeclaration") end, { desc = "Goto Declaration" })
      vim.keymap.set("n", "K", function() vim.fn.CocActionAsync("doHover") end, { desc = "Hover" })
      vim.keymap.set("n", "gK", function() vim.fn.CocActionAsync("showSignatureHelp") end, { desc = "Signature Help" })
      vim.keymap.set("i", "<c-k>", function() vim.fn.CocActionAsync("showSignatureHelp") end, { desc = "Signature Help" })

      -- 代码操作（4 个 codeAction 变体）
      vim.keymap.set({ "n", "x" }, "<leader>ca", function() vim.fn.CocAction("codeAction") end, { desc = "Code Action" })
      vim.keymap.set("n", "<leader>cA", function()
        vim.fn.CocAction("codeAction", nil, "source")
      end, { desc = "Source Action" })
      vim.keymap.set("n", "<leader>cl", function()
        vim.fn.CocAction("codeAction", nil, nil, true)
      end, { desc = "Line Action" })
      vim.keymap.set({ "n", "x" }, "<leader>cr", function()
        vim.fn.CocAction("codeAction", nil, "refactor")
      end, { desc = "Refactor" })
      vim.keymap.set("n", "<leader>rn", function() vim.fn.CocAction("rename") end, { desc = "Rename" })
      vim.keymap.set("n", "<leader>ci", "<Cmd>CocInfo<CR>", { desc = "Coc Info" })
      vim.keymap.set("n", "<leader>cR", "<Cmd>CocCommand workspace.renameCurrentFile<CR>", { desc = "Rename File" })
      vim.keymap.set("n", "<leader>co", function()
        vim.fn.CocAction("runCommand", "editor.action.organizeImport")
      end, { desc = "Organize Imports" })
      vim.keymap.set({ "n", "x" }, "<leader>cc", function() vim.fn.CocAction("codeLensAction") end, { desc = "CodeLens Action" })
      vim.keymap.set("n", "<leader>cC", "<Cmd>CocCommand document.toggleCodeLens<CR>", { desc = "Toggle CodeLens" })
      vim.keymap.set("n", "<leader>cm", "<Cmd>CocCommand loader.open<CR>", { desc = "Coc Extensions" })

      -- 诊断导航
      vim.keymap.set("n", "]d", function() vim.fn.CocAction("diagnosticNext") end, { desc = "Next Diagnostic" })
      vim.keymap.set("n", "[d", function() vim.fn.CocAction("diagnosticPrevious") end, { desc = "Prev Diagnostic" })
      vim.keymap.set("n", "]e", function() vim.fn.CocAction("diagnosticNext") end, { desc = "Next Error" })
      vim.keymap.set("n", "[e", function() vim.fn.CocAction("diagnosticPrevious") end, { desc = "Prev Error" })
      vim.keymap.set("n", "]w", function() vim.fn.CocAction("diagnosticNext") end, { desc = "Next Warning" })
      vim.keymap.set("n", "[w", function() vim.fn.CocAction("diagnosticPrevious") end, { desc = "Prev Warning" })
      vim.keymap.set("n", "<leader>cd", function() vim.fn.CocActionAsync("doHover") end, { desc = "Line Diagnostics" })

      -- Coc 新增
      vim.keymap.set("n", "]g", function() vim.fn.CocAction("diagnosticNext") end, { desc = "Next Diagnostic" })
      vim.keymap.set("n", "[g", function() vim.fn.CocAction("diagnosticPrevious") end, { desc = "Prev Diagnostic" })
      vim.keymap.set("n", "g.", function() vim.fn.CocAction("doQuickfix") end, { desc = "Quickfix" })
      vim.keymap.set("n", "<leader>cs", "<Cmd>CocOutline<CR>", { desc = "Coc Outline" })
      vim.keymap.set("n", "<leader>cS", "<Cmd>CocList outline<CR>", { desc = "Coc List Outline" })
      vim.keymap.set("n", "<leader>xl", "<Cmd>CocList location<CR>", { desc = "Location List" })
      vim.keymap.set("n", "<leader>xq", "<Cmd>CocList quickfix<CR>", { desc = "Quickfix List" })

      -- 格式化
      vim.keymap.set({ "n", "x" }, "<leader>cf", function() vim.fn.CocAction("format") end, { desc = "Format" })

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

      -- 浮动窗口滚动（替代 cmp / noice 的 <C-f> <C-b>）
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

      -- <Esc> 保留清除搜索，移除 cmp snippet_stop
      vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
        vim.cmd("noh")
        return "<esc>"
      end, { expr = true, desc = "Escape and Clear hlsearch" })
    end,
  },
}
```
