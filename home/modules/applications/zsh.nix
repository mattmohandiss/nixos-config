{ pkgs, lib, ... }:

{

  config = {
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
      initContent = ''
				source ${../configs/zshrc}
				source ${../scripts/dev-function.zsh}
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
  };
}
