local function isMacOS()
  local handle = io.popen("uname -s")
  if handle then
    local result = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return result == "Darwin"
  end
  return false
end

return {
    "keaising/im-select.nvim",
    opts = isMacOS() and {
      default_command = "im-select",
    } or {},
}
