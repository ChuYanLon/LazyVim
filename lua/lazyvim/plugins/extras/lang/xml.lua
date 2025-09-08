return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = {
        "xml",
        "xhtml",
        "svg",
        "wsdl",
        "xsl",
        "xslt",
        "xquery",
        "xjb",
        "xsd",
        "xlf",
        "xul",
      },
    })
  end,
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "xml", "html" } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "lemminx" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.tbl_deep_extend("force", opts.servers, {
        lemminx = {},
      })
    end,
  },
}
