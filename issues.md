# Boot Issues — journalctl -b

**Summary**

- System booted to the graphical target successfully, but several warnings and probe failures were logged that may cause reduced functionality (touchpad jitter, missing X integration, camera/sensor issues, portal/pipewire problems).

**Notable Warnings & Errors**

- Touchpad jumps (libinput): "Touch jump detected and discarded" — causes cursor jumps; likely kernel/hardware/driver related.
- Missing XWayland satellite: `error spawning xwayland-satellite at "xwayland-satellite", disabling integration: No such file or directory` — breaks some X11 integration/legacy apps.
- polkit/dbus: `Unknown username "pulse"` and `Unknown group "power"` in message bus config — indicates rule files reference non-existent user/group.
- xdg-desktop-portal errors: "Could not get pidns for pid ...: pidns required but no pidfd provided" — may impair portal registration for sandboxed apps.
- Camera / sensor probe failures:
  - `ov13858 ... probe with driver ov13858 failed with error -22`
  - `int3472-discrete INT3472:01/02: GPIO type ... unknown; the sensor may not work`
  - `acpi_cpufreq: Failed to insert module 'acpi_cpufreq': No such device`
- IOMMU/DMAR messages: several "inconsistent" feature lines and "force enabled due to platform opt in" — informational but relevant for PCI passthrough use.
- WirePlumber / PipeWire assertions: `wp-event-dispatcher_unregister_hook: assertion 'already_registered_dispatcher == self' failed` — possible session manager bug or race.
- Bluetooth: some LE device errors and debug messages (usually harmless unless specific device fails to connect).
- Deprecated API warning: `Socket Thread' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211`.

**Quick Diagnostic Commands**

- Show warnings and errors from this boot:
  - `journalctl -b -p warning..err --no-pager`
- Show failed systemd units:
  - `systemctl --failed`
- Tail kernel messages for the most relevant keywords:
  - `dmesg -T | rg -i "touch jump|ov13858|int3472|xwayland|pidns|wireplumb|acpi_cpufreq|probe failed"`
- Check for XWayland binaries:
  - `which xwayland-satellite || which xwayland`
- PipeWire / WirePlumber recent logs:
  - `journalctl -u pipewire -u wireplumber --since "10 minutes ago"`
- Check polkit rules referencing missing users/groups:
  - `grep -R "pulse" /etc /run /nix -n 2>/dev/null || true`
  - `getent passwd pulse || true`
  - `getent group power || true`

**Suggested Next Steps (prioritized)**

1. Touchpad cursor jumping
   - Reproduce while running `libinput debug-events --verbose` and collect `journalctl -k` output.
   - Try kernel upgrade or libinput update if issue persists.
2. XWayland integration
   - Install or provide `xwayland-satellite` if required by your compositor (or adjust compositor config to not require it).
   - Confirm `xwayland` availability: `which xwayland`.
3. Camera / sensors
   - Investigate `ov13858` and `int3472` probe failures; check `libcamera`/`pipewire` configs and firmware availability.
4. PipeWire / WirePlumber instability
   - Collect `journalctl` logs for `wireplumber` and consider upgrading or switching session manager versions.
5. polkit / dbus unknown user/group
   - Inspect polkit rule files that reference `pulse` or `power` and either create the users/groups or edit rules.
6. xdg-desktop-portal pidns errors
   - These are often caused by sandboxing/container differences; verify portal and runtime environment versions and consider upgrading.

**Options / Next Actions**

- A: Collect targeted logs (run the diagnostic commands and paste output here).
- B: Troubleshoot the touchpad jumps interactively (I can guide you through reproducing and collecting debug info).
- C: Propose NixOS configuration changes to add missing packages or upgrade components (e.g. `xwayland-satellite`, `libinput`, `wireplumber`).


---

File created by assistant from `journalctl -b --no-pager` analysis.
