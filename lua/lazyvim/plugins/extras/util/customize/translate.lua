return {
  "JuanZoran/Trans.nvim",
  lazy = true,
  cmds = {
    "Translate",
    "TranslateInput",
    "TransPlay",
  },
  init = function()
    vim.api.nvim_create_user_command("TransInstall", function()
      require("Trans").install()
    end, {})
  end,
  keys = {
    { "mm", mode = { "n", "x" }, "<Cmd>Translate<CR>", desc = "󰊿 Translate" },
    { "mk", mode = { "n", "x" }, "<Cmd>TransPlay<CR>", desc = " Auto Play" },
    { "mi", "<Cmd>TranslateInput<CR>", desc = "󰊿 Translate From Input" },
  },
  dependencies = { "kkharji/sqlite.lua" },
  opts = {},
}
