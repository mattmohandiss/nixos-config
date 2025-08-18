{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      pyright
      nodePackages.typescript-language-server
      
      # Formatters
      stylua
      black
      nodePackages.prettier
      
      # Tools
      ripgrep
      fd
      unzip
      gzip
    ];

    plugins = with pkgs.vimPlugins; [
      # Plugin manager and dependencies
      lazy-nvim
      plenary-nvim
      nvim-web-devicons
      
      # Core functionality
      nvim-treesitter.withAllGrammars
      telescope-nvim
      nvim-tree-lua
      
      # LSP and completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      friendly-snippets
      
      # UI enhancements
      lualine-nvim
      bufferline-nvim
      gitsigns-nvim
      indent-blankline-nvim
      
      # Quality of life
      which-key-nvim
      comment-nvim
      nvim-autopairs
    ];

    extraLuaConfig = ''
      -- Basic settings
      vim.o.termguicolors = true
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.updatetime = 200
      vim.o.signcolumn = "yes"

      -- Treesitter setup
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        indent = { enable = true },
      })

      -- Telescope setup and keybinds
      require('telescope').setup({})
      local tb = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', tb.find_files, {desc = 'Find files'})
      vim.keymap.set('n', '<leader>fg', tb.live_grep, {desc = 'Live grep'})
      vim.keymap.set('n', '<leader>fb', tb.buffers, {desc = 'Buffers'})
      vim.keymap.set('n', '<leader>fh', tb.help_tags, {desc = 'Help'})

      -- File explorer
      require('nvim-tree').setup({})

      -- Completion setup
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })

      -- LSP setup
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = {'vim'} }
          }
        }
      })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.ts_ls.setup({ capabilities = capabilities })

      -- UI setup
      require('lualine').setup({})
      require('bufferline').setup({})
      require('gitsigns').setup({})
      require('ibl').setup({})

      -- QoL setup
      require('which-key').setup({})
      require('Comment').setup({})
      require('nvim-autopairs').setup({})

      -- Format on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function()
          pcall(vim.lsp.buf.format, { timeout_ms = 1500 })
        end
      })
    '';
  };
}
