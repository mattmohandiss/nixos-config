{ pkgs, ... }:

{
  # GNOME Keyring service for credential management
  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };
}
