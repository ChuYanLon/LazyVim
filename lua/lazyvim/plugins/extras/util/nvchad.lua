return {
  { "nvchad/volt" },
  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    keys = {
      { "<leader>uk", "<cmd>ShowkeysToggle<Cr>", desc = "Show Keys" },
    },
  },
  {
    "nvzone/typr",
    cmd = { "Typr", "TyprStats" },
    keys = {
      { "<leader>ut", "", desc = "typing" },
      { "<leader>utu", "<cmd>Typr<Cr>", desc = "Typing practice" },
      { "<leader>uts", "<cmd>TyprStats<Cr>", desc = "Typing stats" },
    },
    opts = {
      wpm_goal = 120,
      stats_filepath = vim.fn.stdpath("data") .. "/config",
    },
  },
  {
    "nvzone/timerly",
    dependencies = "nvzone/volt",
    cmd = "TimerlyToggle",
    keys = {
      { "<leader>ue", "<cmd>TimerlyToggle<Cr>", desc = "timerly" },
    },
    opts = {}, -- optional
  },
}
