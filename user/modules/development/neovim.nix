{ lib, ... }: {
  programs.nvf = {
    enable = true;

    settings.vim = {
      globals = {
        mapleader = "\\";
        maplocalleader = "\\";
      };

      options = {
        tabstop = 2;
        shiftwidth = 2;
      };

      comments.comment-nvim = {
        enable = true;
        mappings.toggleCurrentLine = "<leader>/";
      };

      # Tree-sitter plugin ONLY (no language assumptions)
      treesitter = {
        enable = true;
        textobjects.enable = true;
      };

      keymaps = lib.mkForce [
        # --- scope navigation ---
        {
          mode = "n";
          key = "<S-Up>";
          action = "<cmd>lua _G.__scope_up()<CR>";
          silent = true;
          desc = "Prev scope/block";
        }
        {
          mode = "n";
          key = "<S-Down>";
          action = "<cmd>lua _G.__scope_down()<CR>";
          silent = true;
          desc = "Next scope/block";
        }
        {
          mode = "n";
          key = "<S-Left>";
          action = "^";
          silent = true;
          desc = "Line start";
        }
        {
          mode = "n";
          key = "<S-Right>";
          action = "$";
          silent = true;
          desc = "Line end";
        }

        {
          mode = "v";
          key = "<S-Up>";
          action = "<cmd>lua _G.__scope_up()<CR>";
          silent = true;
        }
        {
          mode = "v";
          key = "<S-Down>";
          action = "<cmd>lua _G.__scope_down()<CR>";
          silent = true;
        }
        {
          mode = "v";
          key = "<S-Left>";
          action = "^";
          silent = true;
        }
        {
          mode = "v";
          key = "<S-Right>";
          action = "$";
          silent = true;
        }

        # --- Neo-tree ---
        {
          mode = "n";
          key = "<C-Space>";
          action = "<cmd>Neotree toggle<CR>";
          silent = true;
          desc = "Toggle Neo-tree";
        }

        # --- clipboard ---
        {
          mode = "v";
          key = "<C-x>";
          action = "\"+y";
          desc = "Copy";
        }
        {
          mode = "v";
          key = "<C-S-x>";
          action = "\"+d";
          desc = "Cut";
        }
        {
          mode = "n";
          key = "<C-v>";
          action = "\"+p";
          desc = "Paste";
        }
        {
          mode = "i";
          key = "<C-v>";
          action = "<C-r>+";
          desc = "Paste";
        }

        # --- comment toggle ---
        {
          mode = "n";
          key = "<C-/>";
          action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
          silent = true;
        }
        {
          mode = "n";
          key = "<C-_>";
          action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
          silent = true;
        }
        {
          mode = "v";
          key = "<C-/>";
          action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
          silent = true;
        }
        {
          mode = "v";
          key = "<C-_>";
          action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
          silent = true;
        }

        # --- undo / redo ---
        {
          mode = "n";
          key = "<C-z>";
          action = "u";
          silent = true;
        }
        {
          mode = "i";
          key = "<C-z>";
          action = "<C-o>u";
          silent = true;
        }
        {
          mode = "n";
          key = "<C-y>";
          action = "<C-r>";
          silent = true;
        }
        {
          mode = "i";
          key = "<C-y>";
          action = "<C-o><C-r>";
          silent = true;
        }

        # --- select all ---
        {
          mode = "n";
          key = "<C-a>";
          action = "ggVG";
          silent = true;
        }
        {
          mode = "i";
          key = "<C-a>";
          action = "<Esc>ggVG";
          silent = true;
        }
      ];

      luaConfigRC = {
        exrc = {
          after = [ "pluginConfigs" ];
          before = [ ];
          data = ''
            vim.o.exrc = true
            vim.o.secure = true
          '';
        };

        formatOnPaste = {
          after = [ "pluginConfigs" ];
          before = [ ];
          data = ''
            vim.api.nvim_create_autocmd("TextChanged", {
              callback = function()
                if vim.v.event and vim.v.event.operator == "p" then
                  vim.lsp.buf.format({ async = true })
                end
              end,
            })
          '';
        };

        scopeMove = {
          after = [ "pluginConfigs" ];
          before = [ ];
          data = ''
            -- (your scopeMove lua here)
          '';
        };
      };

      filetree.neo-tree = {
        enable = true;
        setupOpts.window = {
          position = "float";
          popup.size = {
            width = "75%";
            height = "75%";
          };
          popup.border = "rounded";
        };
      };

      statusline.lualine.enable = true;


      autocomplete.blink-cmp = {
        enable = true;

        setupOpts.keymap = {
          preset = "default";

          "<Down>" = [ "select_next" "fallback" ];
          "<Up>" = [ "select_prev" "fallback" ];
        };

        # optional: also for ":" cmdline completion
        setupOpts.cmdline.keymap = {
          preset = "cmdline";
          "<Down>" = [ "select_next" "fallback" ];
          "<Up>" = [ "select_prev" "fallback" ];
        };
      };

      # LSP client only (servers started per-project)
      lsp = {
        enable = true;
        formatOnSave = true;
      };
    };
  };
}
