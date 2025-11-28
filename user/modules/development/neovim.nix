{ config, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    opts = {
      termguicolors = true;
      number = true;
      relativenumber = true;
      updatetime = 200;
      signcolumn = "yes";
      tabstop = 2;
      shiftwidth = 2;
      expandtab = false;
      smartindent = true;
      autoindent = true;
    };
    plugins = {
      #lualine.enable = true;
      bufferline.enable = true;
      gitsigns.enable = true;
      "indent-blankline".enable = true;
      "which-key".enable = true;
      "web-devicons".enable = true;
      treesitter.enable = true;
      comment.enable = true;
      "nvim-autopairs".enable = true;
      cmp = {
        enable = true;
        settings = {
          snippet.expand = ''
            function(args) 
              require("luasnip").lsp_expand(args.body)
            end
          '';
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<A-Tab>" = "cmp.mapping.complete()";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
        };
      };
      luasnip.enable = true;
      "cmp-nvim-lsp".enable = true;
      "cmp-buffer".enable = true;
      "cmp-path".enable = true;
      cmp_luasnip.enable = true;
      telescope = {
        enable = true;
        settings = {
          defaults = {
            find_files = {
              hidden = true;
            };
          };
        };
      };
      lsp.enable = true;
      lsp.servers = {
        gopls.enable = true;
        pyright.enable = true;
        ts_ls.enable = true;
        hls = {
          enable = true;
          installGhc = true;
        };
        lua_ls.enable = true;
        nil_ls.enable = true;
      };
      mini.enable = true;
      mini.modules.base16.palette = {
        base00 = "#1d2021"; # Background
        base01 = "#3c3836";
        base02 = "#504945";
        base03 = "#665c54";
        base04 = "#bdae93";
        base05 = "#d5c4a1";
        base06 = "#ebdbb2";
        base07 = "#fbf1c7";
        base08 = "#fb4934"; # Red
        base09 = "#fe8019"; # Orange
        base0A = "#fabd2f"; # Yellow
        base0B = "#b8bb26"; # Green
        base0C = "#8ec07c"; # Aqua
        base0D = "#83a598"; # Blue
        base0E = "#d3869b"; # Purple
        base0F = "#d65d0e"; # Brown
      };
      mini.modules.base16.use_cterm = true;
    };
    keymaps = [
      {
        key = "<leader>ff";
        action = {
          __raw = "require('telescope.builtin').find_files";
        };
        options.desc = "Find files";
      }
      {
        key = "<leader>fg";
        action = {
          __raw = "require('telescope.builtin').live_grep";
        };
        options.desc = "Live grep";
      }
      {
        key = "<leader>fb";
        action = {
          __raw = "require('telescope.builtin').buffers";
        };
        options.desc = "Buffers";
      }
      {
        key = "<leader>fh";
        action = {
          __raw = "require('telescope.builtin').help_tags";
        };
        options.desc = "Help";
      }
      {
        key = "<A-Space>";
        action = {
          __raw = "require('telescope.builtin').find_files";
        };
        options.desc = "Find files (Alt+Space)";
      }
      {
        key = "<A-Right>";
        action = ":BufferLineCycleNext<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<A-Left>";
        action = ":BufferLineCyclePrev<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<A-S-Left>";
        action = ":BufferLineMovePrev<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<A-S-Right>";
        action = ":BufferLineMoveNext<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<A-Escape>";
        action = ":bdelete<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<A-c>";
        action = ''"+y'';
        mode = "v";
        options.silent = true;
      }
      {
        key = "<A-c>";
        action = ''"+yy'';
        mode = "n";
        options.silent = true;
      }
      {
        key = "<A-v>";
        action = ''"+p'';
        mode = "n";
        options.silent = true;
      }
      {
        key = "<A-v>";
        action = "<C-r>+";
        mode = "i";
        options.silent = true;
      }
    ];
    extraConfigLua = ''
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function() 
          local arg = vim.fn.argv(0)
          if arg and vim.fn.isdirectory(arg) == 1 then
            vim.cmd('bdelete')
            vim.defer_fn(function() 
              require('telescope.builtin').find_files()
            end, 10)
          end
        end
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
        callback = function(args) 
          if not (vim.bo[args.buf].buftype == "nofile" or vim.bo[args.buf].buftype == "prompt") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function() 
                vim.lsp.buf.format({ async = false, bufnr = args.buf })
              end,
            })
          end
        end,
      })
    '';
  };
}
