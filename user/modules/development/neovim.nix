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

      #binds.whichKey.enable = true;

      comments.comment-nvim = {
        enable = true;
        mappings.toggleCurrentLine = "<leader>/";
      };

      treesitter = {
        enable = true;
        textobjects.enable = true;
      };

      keymaps = lib.mkForce [
        # --- shift+arrows: scope/block up/down, begin/end of line ---
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

        # optional: make it work while selecting too
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

        # --- clipboard copy/cut/paste (left as-is) ---
        # copy / cut in visual
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

        # paste in normal + insert
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

        # --- comment toggle (Ctrl+/) ---
        # terminals often send Ctrl+/ as <C-_>, so bind both
        {
          mode = "n";
          key = "<C-/>";
          action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
          silent = true;
          desc = "Toggle comment";
        }
        {
          mode = "n";
          key = "<C-_>";
          action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
          silent = true;
          desc = "Toggle comment";
        }
        {
          mode = "v";
          key = "<C-/>";
          action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
          silent = true;
          desc = "Toggle comment";
        }
        {
          mode = "v";
          key = "<C-_>";
          action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
          silent = true;
          desc = "Toggle comment";
        }

        # --- undo / redo ---
        {
          mode = "n";
          key = "<C-z>";
          action = "u";
          silent = true;
          desc = "Undo";
        }
        {
          mode = "i";
          key = "<C-z>";
          action = "<C-o>u";
          silent = true;
          desc = "Undo";
        }
        {
          mode = "n";
          key = "<C-y>";
          action = "<C-r>";
          silent = true;
          desc = "Redo";
        }
        {
          mode = "i";
          key = "<C-y>";
          action = "<C-o><C-r>";
          silent = true;
          desc = "Redo";
        }

        # --- select all ---
        {
          mode = "n";
          key = "<C-a>";
          action = "ggVG";
          silent = true;
          desc = "Select all";
        }
        {
          mode = "i";
          key = "<C-a>";
          action = "<Esc>ggVG";
          silent = true;
          desc = "Select all";
        }
      ];

      luaConfigRC = {
        formatOnPaste = {
          # run after plugins/basic config so vim.lsp + your plugins exist
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
            local function ts_scope_move(dir)
              local ok, ts = pcall(require, "nvim-treesitter.ts_utils")
              if not ok then return false end
              local node = ts.get_node_at_cursor()
              if not node then return false end

              local scope_types = {
                function_definition=true, function_declaration=true, method_definition=true,
                class_definition=true, class_declaration=true,
                if_statement=true, for_statement=true, while_statement=true, do_statement=true,
                block=true, compound_statement=true, program=true,
              }

              local cur = node
              while cur and not scope_types[cur:type()] do
                cur = cur:parent()
              end
              if not cur then return false end

              local sr, sc, er, ec = cur:range()
              if dir == "up" then
                vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
              else
                vim.api.nvim_win_set_cursor(0, { er + 1, ec })
              end
              return true
            end

            _G.__scope_up = function()
              if not ts_scope_move("up") then vim.cmd("normal! {") end
            end
            _G.__scope_down = function()
              if not ts_scope_move("down") then vim.cmd("normal! }") end
            end
          '';
        };
      };

      filetree.neo-tree = {
        enable = true;
        setupOpts = {
          window = {
            position = "float";
            popup = {
              size = {
                width = "75%";
                height = "75%";
              };
              border = "rounded";
            };
          };
        };
      };

      autocomplete.blink-cmp.enable = true;
      statusline.lualine.enable = true;

      lsp = {
        enable = true;
        formatOnSave = true;
      };

      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;

        nix = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          extraDiagnostics.enable = true;
        };

        lua = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          extraDiagnostics.enable = true;
        };

        ts = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          extraDiagnostics.enable = true;
        };

        python = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
        };

        java = {
          enable = true;
          lsp.enable = true;
        };
      };
    };
  };
}
