-- Neovim Lua configuration mirrored from nix config (mattm/applications/neovim.nix)
-- This file bootstraps a Lazy.nvim-based plugin setup and configures core Neovim features
-- Place this file at /etc/nixos/mattm/configs/neovim.lua and load via: require('mattm.configs.neovim')
-- or adjust your init.lua to source this module directly.

local M = {}

M.setup = function()
  -- Bootstrap Lazy.nvim (plugin manager)
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
  end
  vim.opt.rtp:prepend(lazypath)

  -- Plugin specification mirroring nix config
  local plugins = {
    -- Core dependencies
    { "folke/lazy.nvim" },
    { "nvim-tree/nvim-tree.lua" },
    { "nvim-tree/nvim-web-devicons" },

    -- Core functionality and UI
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "rafamadriz/friendly-snippets" },
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "lewis6991/gitsigns.nvim" },
    { "lukas-reineke/indent-blankline.nvim" },
    { "akinsho/bufferline.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "folke/which-key.nvim" },
    { "numToStr/Comment.nvim" },
    { "windwp/nvim-autopairs" },
  }

  require("lazy").setup(plugins, {})

  -- Basic UI and editor options
  vim.o.termguicolors = true
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.updatetime = 200
  vim.o.signcolumn = "yes"

  -- Treesitter
  require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
  })

  -- Telescope setup and keybindings
  require("telescope").setup({})
  local tb = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", tb.live_grep, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>fh", tb.help_tags, { desc = "Help" })

  -- NvimTree setup
  require("nvim-tree").setup({})

  -- Completion setup (nvim-cmp with LuaSnip)
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
      { name = "path" },
    })
  })

  -- LSP setup
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local lspconfig = require("lspconfig")
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } }
      }
    }
  })
  lspconfig.pyright.setup({ capabilities = capabilities })
  lspconfig.tsserver.setup({ capabilities = capabilities })

  -- UI enhancements
  require("lualine").setup({})
  require("bufferline").setup({})
  require("gitsigns").setup({})
  require("ibl").setup({})

  -- Quality-of-life
  require("which-key").setup({})
  require("Comment").setup({})
  require("nvim-autopairs").setup({})

  -- Format on save (LSP)
  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
      pcall(vim.lsp.buf.format, { timeout_ms = 1500 })
    end
  })
end

-- Execute setup on load
M.setup()

return M
