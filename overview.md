# NixOS Configuration Overview

## Complete Feature Listing

### System-Level Features

**Boot & Kernel**
- systemd-boot bootloader with 10 generation limit
- Kernel params optimized for Surface Pro 8 (deep sleep, crash handling, NVMe/Intel graphics tuning)
- Surface-specific kernel modules (surface_aggregator, surface_hid_core, surface_hid, surface_kbd)
- LUKS encryption for root and swap partitions
- KVM-intel virtualization

**Audio**
- PipeWire with ALSA, PulseAudio, and JACK support
- 32-bit audio support enabled
- WirePlumber session manager

**Gaming**
- Steam with Gamescope session
- start/end scripts ( GameMode with customCPU governor, I/O scheduler, fan control)
- Thermal management via thermald with custom config for Surface Pro 8
- power-profiles-daemon
- GPU monitoring (MangoHud, intel-gpu-tools)
- User added to `gamemode` and `video` groups

**Networking**
- NetworkManager with firewall (ports 8200, 1900, BitTorrent 6881-6999)
- Eduroam WiFi profile preconfigured
- SSL certificate for eduroam

**Wayland Desktop**
- Niri window manager (unstable) with custom keybindings
- greetd + tuigreet login manager
- XWayland support via xwayland-satellite
- XDG portals with default "*" config
- Danish keyboard layout

**Power Management**
- logind lid switch handling (suspend on lid close)
- UPower with battery thresholds (20% low, 5% critical, 3% action)
- Automatic timezone via automatic-timezoned

**Security**
- GNOME Keyring with D-Bus
- PolKit authentication agent
- PAM integration for keyring unlock

**System Services**
- iptsd (touchscreen)
- updates
- Mini fwupd firmwareDLNA media server (port 8200, /srv/media)
- Journald with 30-day retention
- systemd coredump collection (2GB max)
- IIO hardware sensors

**System Packages**
- ffmpeg, pulseaudio, pavucontrol
- home-manager CLI
- ripgrep, fd, neovim, git
- Nerd Fonts (Fira Code, JetBrains Mono, Hack)

---

### User-Level Features (Home Manager)

**Shell**
- Zsh with autosuggestion, syntax highlighting, fzf integration
- Starship prompt
- eza, bat, zoxide
- Kitty terminal (11pt, remote control enabled)
- direnv with nix-direnv

**Desktop (Niri)**
- Application launchers: fuzzel, tofi-drun
- Window management with column-based layout
- Screenshot scripts (interactive, raw PNG, OCR)
- Brightness/volume/media keybindings
- Quick terminal (kitten) and LLM chat (uv tool run llm)
- XDG_CURRENT_DESKTOP set to GNOME for compatibility

**Development**
- Neovim (unstable with Lua config)
- VSCodium with Python, path-intellisense, direnv extensions
- Git (name, email, GPG signing with key 381948BAC468E711)
- LazyGit
- Node.js, Bun runtime
- Cargo, cmake, luarocks, just

**Browsers**
- Firefox with CascadeFox theme, uBlock Origin, Bitwarden
- Zen Browser (Aurora) with locked privacy policies, extensions

**Media**
- mpv player
- Swww wallpaper daemon
- Mako notifications (top-right, 5s timeout)
- Discord, Zoom, Steam

**Downloads**
- aria2 with magnet link handler

**Graphics**
- grim, slurp (screenshots)
- tesseract (OCR)
- GIMP, Blender, Godot
- Microsoft Edge, Love (game engine)

**Utilities**
- fuzzel (launcher)
- brightnessctl, pwvucontrol
- wl-clipboard, wvkbd, wlr-randr
- btop, eza, bat
- lazygit, just
- zathura PDF viewer

**Secrets**
- GPG with GPG-agent
- GNOME Keyring daemon

**XDG**
- MIME associations (Firefox for web/PDF/images, mpv for media, nvim for text, nautilus for directories)

**Theming**
- Stylix with Gruvbox Dark Hard base16 scheme
- Fira Code Nerd Font monospace
- Firefox/Zen browser theme integration

---

### Hardware Target
- **Primary**: Microsoft Surface Pro 8 (Intel Tiger Lake)
- Intel CPU with microcode updates
- Bluetooth enabled with power on boot

---

### Flake Inputs
- nixpkgs/nixos-unstable
- NUR (user packages)
- home-manager
- niri (Sodiboo)
- zen-browser
- nvf (Neovim flake)
- stylix
