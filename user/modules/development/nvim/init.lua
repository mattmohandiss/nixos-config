-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "´"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.fillchars = { eob = " " }

vim.o.winborder = "rounded"
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- Buffer navigation
vim.keymap.set("n", "<C-Left>", "<cmd>bprevious<CR>", { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<C-Right>", "<cmd>bnext<CR>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<C-q>", "<cmd>bdelete<CR>", { desc = "Close buffer", silent = true })
vim.keymap.set("n", "<C-CR>", ":", { desc = "Command line" })
vim.keymap.set("n", "<C-u>", "<cmd>undo<CR>", { desc = "Undo", silent = true })
vim.keymap.set("n", "<C-r>", "<cmd>redo<CR>", { desc = "Redo", silent = true })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save", silent = true })
-- Formatting is LSP-specific and is registered per-buffer in LspAttach
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to clipboard", silent = true })
vim.keymap.set("v", "<C-x>", '"+d', { desc = "Cut to clipboard", silent = true })
vim.keymap.set("i", "<C-v>", "<C-r><C-p>+", { desc = "Paste from clipboard", silent = true })
-- Comment toggles moved to the Comment.nvim plugin spec (lua/plugins/comment.lua)
vim.keymap.set("n", "<Esc>", function()
	local win = vim.api.nvim_get_current_win()
	local cfg = vim.api.nvim_win_get_config(win)

	if cfg.relative ~= "" then
		vim.api.nvim_win_close(win, true)
	else
		vim.cmd("noh")
	end
end, { silent = true })

vim.o.updatetime = 250

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = bufnr, desc = "Format" })

    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
end,
})

-- Remove conflicting <C-F> mapping inside Mason UI buffers
-- (Optional) If you still want to block <C-F> inside mason, uncomment below.
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "mason",
--   callback = function()
--     pcall(vim.keymap.del, 'n', '<C-F>', { buffer = true })
--     pcall(vim.keymap.del, 'i', '<C-F>', { buffer = true })
--   end,
-- })

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},

	checker = { enabled = true },

	ui = {
		border = "rounded",
	},
})
