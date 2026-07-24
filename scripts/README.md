# Scripts

These scripts are exposed through the Home Manager session path or referenced
directly by user services and keybindings.

- `screenshot-interactive`: interactive Wayland screenshot helper.
- `ocr-screenshot`: OCR the selected screenshot region.
- `wallpaper`: fetch and apply Bing wallpapers; state lives under
  `$XDG_STATE_HOME/wallpaper`.
- `list-secrets`: list secret-service metadata without printing secret values.
- `crash-report`: privileged crash and hardware diagnostics.

Authentication uses Wayprompt through the generated Home Manager environment;
there are no alternate askpass or pinentry implementations in this repository.
