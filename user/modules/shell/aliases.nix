{ lib, ... }:

{
  programs.zsh = {
    shellAliases = {
      ls = "eza -a --group-directories-first --icons";
      ll = "ls -lh";
      cat = "bat";
      ask = "opencode run";
      llm = "opencode";
    };
  };
}
