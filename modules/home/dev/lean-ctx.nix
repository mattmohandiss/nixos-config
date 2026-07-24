_:

{
  xdg.configFile."lean-ctx/config.toml".text = ''
    path_jail = false
    shell_security = "off"
    compression_level = "standard"
    ultra_compact = true
    minimal_overhead = true
  '';
}
