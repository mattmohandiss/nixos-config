{ inputs, ... }:

{
  xdg.configFile."opencode" = {
    source = "${inputs.self}/modules/home/dev/opencode";
  };
}
