local M = {}

local function trim(s) return (s or ""):gsub("^%s+", ""):gsub("%s+$", "") end

local function just_recipes()
	local out = vim.fn.systemlist({ "just", "--summary" })
	if vim.v.shell_error ~= 0 then return nil, "No Justfile here (or `just` missing)" end
	local names = {}
	if out[1] then for n in out[1]:gmatch("%S+") do names[#names+1] = n end end
	table.sort(names)
	return names
end

local function open_log_buf(title)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_name(buf, title)

	vim.cmd("botright 15split")
	vim.api.nvim_win_set_buf(0, buf)
	return buf
end

local function run_to_log(cmd, title)
	local buf = open_log_buf(title or cmd)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "$ " .. cmd, "" })

	vim.system({ "sh", "-lc", cmd }, { text = true }, function(res)
		local out = (res.stdout or "") .. (res.stderr or "")
		local lines = vim.split(out, "\n", { plain = true })
		vim.schedule(function()
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", ("[exit %d]"):format(res.code or -1) })
			vim.bo[buf].modifiable = false
		end)
	end)
end

function M.pick()
	local names, err = just_recipes()
	if not names then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end

	local items = vim.tbl_map(function(name)
		return { text = name, recipe = name }
	end, names)

	Snacks.picker({
		title = "Just",
		items = items,
		format = function(item) return { { item.text, nil } } end,
		confirm = function(picker, item)
			picker:close()
			if not item then return end

			vim.ui.input({ prompt = "Args (optional): ", default = "" }, function(args)
				if args == nil then return end
				args = trim(args)

				local cmd = "just " .. vim.fn.shellescape(item.recipe)
				if args ~= "" then cmd = cmd .. " " .. args end
				run_to_log(cmd, "just " .. item.recipe)
			end)
		end,
	})
end

return M

