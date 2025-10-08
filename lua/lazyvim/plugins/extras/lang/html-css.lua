local list_insert_unique = require("utils").list_insert_unique
local filetypes = {
  "css",
  "eruby",
  "html",
  "htmldjango",
  "javascriptreact",
  "less",
  "pug",
  "sass",
  "scss",
  "typescriptreact",
  "vue",
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.tbl_deep_extend("force", opts.servers, {
        emmet_language_server = {
          init_options = {
            --- @type boolean Defaults to `true`
            showAbbreviationSuggestions = false,
            --- @type "always" | "never" Defaults to `"always"`
            showExpandedAbbreviation = "always",
            --- @type boolean Defaults to `false`
            showSuggestionsAsSnippets = true,
          },
          filetypes,
        },
        html = {
          init_options = {
            provideFormatter = false,
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
              css = true,
              javascript = true,
            },
          },
        },
        cssmodules_ls = {
          capabilities = {
            definitionProvider = false,
          },
          init_options = { camelCase = "dashes" },
        },
        cssls = {
          init_options = { provideFormatter = false },
          settings = {
            css = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
            less = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = false,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        list_insert_unique(opts.ensure_installed, {
          "html",
          "css",
          "scss",
        })
      end
      vim.treesitter.language.register("scss", "less")
      vim.treesitter.language.register("scss", "postcss")
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      list_insert_unique(opts.ensure_installed, {
        "html-lsp",
        "cssmodules-language-server",
        "css-lsp",
        "emmet-language-server",
      })
    end,
  },
  {
    "nvim-mini/mini.icons",
    optional = true,
    opts = {
      filetype = {
        postcss = { glyph = "󰌜", hl = "MiniIconsOrange" },
      },
    },
  },
  {
    "Jezda1337/nvim-html-css",
    lazy = true,
    event = "VeryLazy",
    dependencies = { "saghen/blink.cmp", "nvim-treesitter/nvim-treesitter" }, -- Use this if you're using blink.cmp
    opts = {
      enable_on = {
        "html",
        "htmldjango",
        "tsx",
        "jsx",
        "erb",
        "svelte",
        "vue",
        "blade",
        "php",
        "templ",
        "astro",
      },
      handlers = {
        definition = {
          bind = "gd",
        },
        hover = {
          bind = "K",
          wrap = true,
          border = "none",
          position = "cursor",
        },
      },
      documentation = {
        auto_show = true,
      },
      style_sheets = {},
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "Kaiser-Yang/blink-cmp-avante", "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "html-css" },
        providers = {
          ["html-css"] = {
            name = "html-css",
            module = "blink.compat.source",
          },
        },
      },
    },
  },
}
