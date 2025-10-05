{ lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";

    shellAliases = {
      ls = "eza --group-directories-first --icons";
      ll = "ls -lh";
      la = "ls -la";
      cat = "bat";
      grep = "rg";
      find = "fd";
      gs = "git status -sb";
    };

    initContent = ''
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt GLOB_DOTS
      setopt NUMERIC_GLOB_SORT
      setopt NO_BEEP

      zmodload zsh/complist
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' squeeze-slashes true

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

      source ${../scripts/dev-function.zsh}
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza.enable = true;
  programs.bat.enable = true;
  programs.zoxide.enable = true;
  programs.starship.enable = true;
}
