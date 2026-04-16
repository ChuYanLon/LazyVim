return {
	"uga-rosa/translate.nvim",
	config = function()
		vim.api.nvim_set_keymap('n', 'mm', "viw:Translate ZH<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap('v', 'mm', ":'<,'>Translate ZH<CR>",
			{ noremap = true, silent = true })
		vim.api.nvim_set_keymap('n', 'mr', "viw:Translate ZH -output=replace<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap('v', 'mr', ":'<,'>Translate ZH -output=replace<CR>", { noremap = true, silent = true })
		require("translate").setup({
			default = {
				command = "translate_shell",
			},
			preset = {
				command = {
					translate_shell = {
						args = { "-e", "bing" }
					}
				}
			}
		})
	end
}
