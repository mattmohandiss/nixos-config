{ pkgs, ... }:

{
  # Kitty terminal emulator configuration
  programs.kitty = {
    enable = true;
    settings = {
      # Disable confirmation when closing window
      confirm_os_window_close = 0;

      # Enable better font rendering
      disable_ligatures = "never";
      allow_remote_control = "yes";

      # Set default font size (kitty uses float values)
      font_size = 11.0;
    };
    keybindings = {
      # System clipboard copy/paste - following Ctrl-based hierarchy
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };
}
