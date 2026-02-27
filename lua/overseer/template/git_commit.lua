return {
  name = "git commit (local)",
  params = {
    args = { optional = true, type = "list", delimiter = " " },
    cwd = {
      optional = false,
      type = "enum",
      default = vim.fn.getcwd(),
      choices = { vim.fn.getcwd(), vim.fn.expand("%:p:h") },
    },
  },
  builder = function(params)
    local args = { vim.fn.expand("%:p") }
    if params.args then
      args = vim.list_extend(args, params.args)
    end
    return {
      name = "git commit (local)",
      cmd = { "sh", vim.fn.expand("~/.config/nvim/sh/commit.sh") },
      args = args,
      cwd = params.cwd,
      env = {
        OVERSEER_RUNNING = "1",
      },
      components = {
        "on_exit_set_status",
        "on_complete_notify",
      },
    }
  end,
}
