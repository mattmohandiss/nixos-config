{
  config,
  ...
}:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Matt Mohandiss";
        email = "mattmohandiss@gmail.com";
      };
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "simple";
      branch.autosetupmerge = "always";
      core.editor = "nvim";
      core.autocrlf = "input";
       credential.helper = "libsecret";
       core.askpass = "/etc/nixos/scripts/zenity-askpass";
       commit.gpgsign = true;
       user.signingkey = "381948BAC468E711";
    };
  };
}
