local PICKER_NAME = "file management"

local function normalize_path(path)
	return vim.fs.normalize(path)
end

local function get_relative_path(path)
	return vim.fn.fnamemodify(path, ":~:.")
end

local function split_input(input_str)
	if not input_str or input_str == "" then
		return {}
	end
	return vim.split(input_str, ",", { trimempty = true })
end

local function trim(str)
	return vim.trim(str)
end

local function is_directory_path(path)
	return path:sub(-1) == "/" or path:sub(-1) == "\\"
end

local function create_files_or_dirs(base_dir, input_str, opts)
	if not input_str or input_str == "" then
		return
	end

	local items = split_input(input_str)
	local created_files = {}

	for _, item in ipairs(items) do
		item = trim(item)
		if item == "" then
			goto continue
		end

		-- Remove trailing slash from base_dir if present to avoid double slashes
		local clean_base_dir = base_dir:gsub("/+$", "")
		local target = normalize_path(clean_base_dir .. "/" .. item)

		if is_directory_path(item) then
			vim.fn.mkdir(target, "p")
			vim.notify("Created directory: " .. get_relative_path(target))
		else
			-- Create file
			local parent = vim.fn.fnamemodify(target, ":h")
			vim.fn.mkdir(parent, "p")
			if vim.fn.filereadable(target) == 0 then
				local f = io.open(target, "w")
				if f then
					f:close()
				end
				vim.notify("Created file: " .. get_relative_path(target))
				table.insert(created_files, target)
			else
				vim.notify("File already exists: " .. get_relative_path(target))
			end
		end
		::continue::
	end

	-- Open created files if requested
	if opts and opts.open_file and #created_files > 0 then
		vim.schedule(function()
			if opts.open_all_files then
				-- Open all created files
				vim.cmd("edit " .. vim.fn.fnameescape(created_files[1]))

				-- Open remaining files in new buffers
				for i = 2, #created_files do
					vim.cmd("badd " .. vim.fn.fnameescape(created_files[i]))
				end
			else
				-- Only open the first file (backward compatibility)
				vim.cmd("edit " .. vim.fn.fnameescape(created_files[1]))
			end
		end)
	end
end

return {
	"folke/snacks.nvim",
	keys = {
		{
			"<leader>n",
			function()
				Snacks.picker.files({
					title = PICKER_NAME,
					cmd = "fd",
					args = {
				       '--color',
               'never',
                '--type', 
                 'f',
                 '--type', 
                 'd'
					},
				})
			end,
			desc = "files",
		},
	},
	---@type snacks.Config
	opts = {
		picker = {
			actions = {
				createFileOrDir = function(picker)
					local current = picker:current()
					if current then
						if picker.title == PICKER_NAME and is_directory_path(current.file) then
							local filePath = current.file
							local parentPath = ""
							if filePath and vim.fn.fnamemodify(filePath, ":h") ~= "." then
								parentPath = vim.fs.normalize(vim.uv.cwd() or ".")
									.. "/"
									.. vim.fn.fnamemodify(filePath, ":h")
									.. "/"
							else
								parentPath = vim.fs.normalize(vim.uv.cwd() or ".") .. "/"
							end
							if parentPath then
								vim.ui.input({
									prompt = "Enter name to create (dirs end with /, comma-separated)",
									default = "",
									completion = "file",
								}, function(input)
									if input then
										create_files_or_dirs(parentPath, input)
									end
									vim.schedule(function()
										vim.cmd("stopinsert")
										picker:refresh()
									end)
								end)
								vim.schedule(function()
									vim.cmd("startinsert!")
								end)
							end
						else
							picker:action("confirm")
						end
					end
				end,
				fileUtils = function(picker)
					local current = picker:current()
					if current ~= nil and picker.title == PICKER_NAME then
						vim.ui.select({ "remove", "delete" }, {
							prompt = "Select operations:",
						}, function(choice)
							if choice == "remove" then
								local filePath = vim.fs.normalize(vim.uv.cwd() or ".") .. "/" .. current.file
								vim.ui.input({
									prompt = "rename file",
									default = filePath,
									completion = "file",
								}, function(input)
									if input then
										Snacks.rename.rename_file({
											from = filePath,
											to = input,
											on_rename = function(to, from, ok)
												if ok then
													vim.notify(
														"Renamed file: "
															.. get_relative_path(from)
															.. " -> "
															.. get_relative_path(to),
														vim.log.levels.INFO
													)
													picker:refresh()
												else
													vim.notify(
														"Failed to rename file: " .. get_relative_path(from),
														vim.log.levels.ERROR
													)
												end
											end,
										})
									end
									vim.schedule(function()
										vim.cmd("stopinsert")
										picker:refresh()
									end)
								end)
								vim.schedule(function()
									vim.cmd("startinsert!")
								end)
							elseif choice == "delete" then
								local filePath = vim.fs.normalize(vim.uv.cwd() or ".") .. "/" .. current.file
								vim.ui.select({ "yes", "no" }, {
									prompt = "Delete " .. get_relative_path(filePath) .. " ?",
								}, function(v)
									if v == "yes" then
										local bufnr = vim.fn.bufnr(filePath)
										if bufnr ~= -1 then
											vim.api.nvim_buf_delete(bufnr, { force = true })
										end
										require("snacks.explorer.actions").trash(filePath)
										picker:refresh()
									end
								end)
							end
						end)
					end
				end,
			},
			win = {
				input = {
					keys = {
						["<c-x>"] = { "fileUtils", mode = { "n", "i" } },
						["<CR>"] = { "createFileOrDir", mode = { "n", "i" } },
					},
				},
			},
			layout = {
				preset = function()
					return vim.o.columns >= 120 and "ivy" or "vertical"
				end,
			},
			layouts = {
				ivy = {
					layout = {
						box = "vertical",
						backdrop = false,
						row = -1,
						width = 0,
						height = 0.6,
						title_pos = "left",
						{
							box = "horizontal",
							border = "rounded",
							{ win = "list", width = 0.4 },
							{ win = "preview", title = "{preview}", border = "left" },
						},
						{
							win = "input",
							height = 1,
							border = "rounded",
							title = "{title} {live} {flags}",
							title_pos = "center",
						},
					},
				},
			},
			sources = {
				lines = {
					layout = {
						preset = function()
							return vim.o.columns >= 120 and "ivy" or "vertical"
						end,
					},
				},
			},
		},
	},
}
