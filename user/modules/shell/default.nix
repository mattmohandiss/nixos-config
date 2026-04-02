{ lib
, pkgs
, ...
}:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "emacs";

      shellAliases = {
        ls = "eza -a --group-directories-first --icons";
        cat = "bat";
        ask = "opencode run";
        llm = "opencode";
      };

      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
      ];

      initContent = lib.mkMerge [
        (lib.mkOrder 450 ''
          zstyle ':completion:*' menu no
          zstyle ':completion:*:descriptions' format '[%d]'
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' squeeze-slashes true
        '')
        (lib.mkOrder 550 ''
          setopt AUTO_CD
          setopt AUTO_PUSHD
          setopt PUSHD_IGNORE_DUPS
          setopt GLOB_DOTS
          setopt NUMERIC_GLOB_SORT
          setopt NO_BEEP

          HISTSIZE=100000
          SAVEHIST=100000
          HISTFILE="$HOME/.zsh_history"

          setopt HIST_IGNORE_ALL_DUPS
          setopt INC_APPEND_HISTORY_TIME
          setopt SHARE_HISTORY
          setopt HIST_FCNTL_LOCK
          setopt EXTENDED_HISTORY

          export EDITOR="nvim"
          export PAGER="less -R"

          compdef ls=eza

          zstyle ':fzf-tab:*' switch-group '<' '>'
        '')
      ];
    };

    fzf = {
      enable = true;
      enableZshIntegration = false;
    };

    eza.enable = true;
    bat.enable = true;
    zoxide.enable = true;
    starship.enable = true;

    kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
        disable_ligatures = "never";
        allow_remote_control = "yes";
        font_size = 11.0;
      };
      keybindings = {
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
