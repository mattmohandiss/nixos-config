{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;                         # Enable zsh as a login/interactive shell
    enableCompletion = true;               # Load zsh's completion system (compinit)
    autosuggestion.enable = true;          # Fish‑style ghost text suggestions
    syntaxHighlighting.enable = true;      # Colorize commands as you type
    defaultKeymap = "emacs";               # Or "vi" for modal editing

    # History configuration
    history = {
      size = 100000;
      save = 100000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
      extended = true;
    };

    # Shell initialization
    initExtra = ''
      # Navigation / globbing quality of life
      setopt AUTO_CD                       # 'foo' == 'cd foo' if it's a dir
      setopt AUTO_PUSHD                    # cd pushes dir stack; use 'dirs' to see
      setopt PUSHD_IGNORE_DUPS             # Don't duplicate entries in stack
      setopt GLOB_DOTS                     # Include dotfiles in globs (e.g. * matches .env)
      setopt NUMERIC_GLOB_SORT             # Sort files numerically (2<10)
      setopt NO_BEEP                       # Disable terminal bell

      # Smarter completion UI
      zmodload zsh/complist
      zstyle ':completion:*' menu select   # Arrow-key selection
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # Case-insensitive
      zstyle ':completion:*' list-colors ''' # Use LS_COLORS
      zstyle ':completion:*' squeeze-slashes true

      # Prefer modern replacements
      alias ls='eza --group-directories-first --icons'  # Safer 'ls' upgrade
      alias ll='ls -lh'                                 # Long, human sizes
      alias la='ls -la'                                 # Show dotfiles
      alias cat='bat'                                   # Pager with syntax highlight
      alias grep='rg'                                   # Faster grep
      alias find='fd'                                   # Friendly find
      alias gs='git status -sb'                         # Concise git status

      export EDITOR="nvim"                              # Default editor
      export PAGER="less -R"                            # Preserve colors in pager

      # fzf keybinds/completion (provided by programs.fzf.* below)
      # zoxide (smart cd) hook
      eval "$(zoxide init zsh)"

      # Starship prompt (fast, pretty, git-aware)
      eval "$(starship init zsh)"

      # direnv hook (preserve existing functionality)
      eval "$(direnv hook zsh)"
    '';
  };

  # Nice CLI tools with shell integration where available
  programs.fzf = {
    enable = true;                        # CTRL‑R history search, TAB completion
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;                        # Per‑dir envs
    nix-direnv.enable = true;             # Fast, reproducible Nix shells
  };

  programs.eza.enable = true;             # better ls
  programs.bat.enable = true;             # cat with syntax highlighting
  programs.zoxide.enable = true;          # Smarter cd
  programs.starship.enable = true;        # Shell prompt
}
