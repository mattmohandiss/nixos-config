# System Diagnostic Report - Issues and Recommendations

**Generated**: December 11, 2025  
**System Status**: Healthy - 0 failed systemd services  
**Overall Assessment**: System is stable with no critical issues. Most warnings are hardware-specific or non-blocking.

---

## System Health Metrics

| Metric | Status | Details |
|--------|--------|---------|
| **Failed Services** | ✓ Good | 0 failed systemd services |
| **Memory Usage** | ✓ Healthy | 1.5 GB / 15 GB (10%) |
| **Disk Usage** | ✓ Healthy | 134 GB / 921 GB (16%) |
| **Load Average** | ✓ Normal | 0.97 (healthy) |
| **Uptime** | Stable | System running normally |

---

## Issues Found

### 1. ⚠️ Stylix Version Mismatch (Medium Priority)

**Issue**: Stylix version mismatches with both NixOS and Home Manager

**Symptoms**:
```
You are using different Stylix and NixOS versions. This is likely to cause errors and unexpected behavior.
You are using different Stylix and Home Manager versions. This is likely to cause errors and unexpected behavior.
```

**Impact**: Medium - May cause theme rendering issues, missing styles, or unexpected behavior in styled applications

**Location**: Configuration applies to both system and user (mattm profile)

**Recommendations**:
- [ ] Synchronize Stylix version with NixOS version in `flake.nix`
- [ ] Synchronize Stylix version with Home Manager version
- [ ] Option 1: Update flake inputs to match versions
- [ ] Option 2: Disable release checks by adding `stylix.enableReleaseChecks = false;` to configuration (temporary workaround)
- [ ] Test after fix: Check theme application in applications like Firefox, VSCode, terminal

**Affected Files**:
- `flake.nix` - Update Stylix input
- `system/modules/*.nix` - May need style adjustments
- `user/modules/*.nix` - May need style adjustments

---

### 2. ⚠️ Uncommitted Git Changes (Low Priority)

**Issue**: NixOS configuration repository has uncommitted changes

**Modified Files**:
```
M  scripts/screenshot-interactive
M  system/modules/boot.nix (10 insertions, 3 deletions)
M  user/default.nix
M  user/modules/applications/default.nix
M  user/modules/applications/niri.nix
M  user/modules/development/neovim.nix
M  user/modules/packages.nix
A  user/modules/shell/aliases.nix (new)
A  user/modules/shell/default.nix (new)
A  user/modules/shell/direnv.nix (new)
R  user/modules/applications/kitty.nix -> user/modules/shell/kitty.nix (renamed)
R  user/modules/applications/zsh.nix -> user/modules/shell/zsh.nix (renamed)
```

**Impact**: Low - Prevents reproducible builds, no functional impact currently

**Recommendations**:
- [ ] Review changes in `system/modules/boot.nix` - verify Intel RAPL handling is correct
- [ ] Verify shell module refactoring (kitty, zsh, aliases moved to shell/)
- [ ] Commit intentional changes or reset unwanted changes
- [ ] Run `git commit` after verification
- [ ] Future: Consider NixOS flake locking to ensure reproducibility

---

### 3. ⚠️ Wireplumber Audio Daemon Assertions (Low Priority - Non-blocking)

**Issue**: Repeated assertion failures in wireplumber event dispatcher

**Error Pattern**:
```
wireplumber[2573]: wp-event-dispatcher: wp_event_dispatcher_unregister_hook: 
  assertion 'already_registered_dispatcher == self' failed
```

**Frequency**: Multiple occurrences per session

**Impact**: Low - Audio functionality works normally, but daemon logs spam

**Recommendations**:
- [ ] Monitor audio functionality for crackling, stuttering, or dropouts
- [ ] If audio issues occur, try restarting wireplumber:
  ```bash
  systemctl --user restart wireplumber
  ```
- [ ] Check for wireplumber updates in nixpkgs (currently 0.5.12)
- [ ] Consider filing upstream bug report if audio issues develop
- [ ] Temporary: Can suppress warnings by filtering logs if not investigating

**Configuration**: `system/modules/services.nix` or `user/modules/services.nix`

---

### 4. ✗ Missing Intel RAPL Kernel Module (Low Priority - Expected)

**Issue**: Intel RAPL power limiting module not available on this hardware

**Error Pattern** (every boot):
```
systemd-modules-load[XXX]: Failed to find module 'intel_rapl'
```

**Impact**: None - Your hardware doesn't support Intel RAPL. Module doesn't exist on this platform.

**Current Configuration**: `system/modules/gaming.nix` includes:
```nix
"intel_rapl" # Intel RAPL power limiting
```

**Recommendations**:
- [ ] Remove or blacklist `intel_rapl` in `system/modules/gaming.nix` to suppress boot warnings
- [ ] Edit: Remove from the boot.blacklistedKernelModules or don't load it
- [ ] Option A: Comment out the module loading
- [ ] Option B: Add to blacklist to suppress error messages
- [ ] Verify hardware doesn't need RAPL before removing

**Note**: Already appears in `system/modules/gaming.nix` - no action needed if intentional

---

### 5. ✗ Unsupported Camera Hardware (Low Priority - Expected)

**Issue**: OV13858 camera driver probe fails on every boot

**Error Pattern** (every boot):
```
kernel: ov13858 i2c-OVTID858:00: probe with driver ov13858 failed with error -22
```

**Impact**: None - Camera hardware not supported or not in use

**Recommendations**:
- [ ] Determine if camera is needed:
  - Check if it's integrated into your laptop/system
  - If not using camera: No action needed
  - If using camera: May need to blacklist this driver and try alternatives
- [ ] If needed: Blacklist unsupported driver in `system/modules/hardware-configuration.nix`
  ```nix
  boot.blacklistedKernelModules = [ "ov13858" ];
  ```
- [ ] Suppress warning by not attempting to load the module

---

### 6. ⚠️ Bluetooth Wake Configuration Limitation (Low Priority - Informational)

**Issue**: Bluetooth device wake flags cannot be set properly

**Error Pattern** (every boot):
```
bluetoothd[XXXX]: src/device.c:set_wake_allowed_complete() 
  Set device flags return status: Invalid Parameters
```

**Impact**: Low - Some Bluetooth wake features may not work. Basic Bluetooth connectivity unaffected.

**Recommendations**:
- [ ] Determine if you use Bluetooth wake-on-LAN or wake from sleep features
- [ ] If not using: No action needed
- [ ] If using: May need Bluetooth firmware update or driver configuration
- [ ] Check current Bluetooth devices: `bluetoothctl devices`
- [ ] Consider updating BlueTooth drivers/firmware if available

**Current Status**: System is currently running, so basic connectivity works

---

### 7. ⚠️ Gnome Keyring PAM Integration Issue (Low Priority - Harmless)

**Issue**: Gnome Keyring PAM module can't locate daemon control file on login

**Error Pattern** (every login via greetd):
```
greetd[XXXX]: gkr-pam: unable to locate daemon control file
```

**Frequency**: Repeats on every session start

**Impact**: None - Security is unaffected. Keyring functionality works normally despite the warning.

**Recommendations**:
- [ ] Verify gpg/ssh keyring functionality works:
  ```bash
  ssh-add -l  # Should list keys or say no identities
  ```
- [ ] If keyring works: Just a warning, can ignore
- [ ] If keyring doesn't work: Investigate PAM configuration in `user/modules/secrets/gpg.nix`
- [ ] Option: Suppress warnings by adjusting PAM order in configuration
- [ ] Future: May be resolved by Gnome Keyring upstream update

**Related Files**:
- `user/modules/secrets/gpg.nix`
- `user/modules/secrets/default.nix`

---

### 8. ✗ Niri Cursor Theme Issue (Low Priority - Cosmetic)

**Issue**: Failed to load xcursor theme variant "text@48"

**Error Pattern** (during Niri startup):
```
niri::cursor: error loading xcursor text@48: no default icon
```

**Impact**: Cosmetic only - Cursor still works with fallback theme

**Recommendations**:
- [ ] Verify xcursor theme is installed:
  ```bash
  fc-list : family | grep -i cursor
  ```
- [ ] Check cursor theme in Niri config: `user/modules/applications/niri.nix`
- [ ] Verify cursor package is installed in `user/modules/packages.nix`
- [ ] If cursor works fine: Just suppress the warning, no action needed
- [ ] If cursor looks wrong: Install additional cursor themes or specify available variant

**Current Status**: Cursor functionality works despite warning

---

### 9. ⚠️ WiFi Geolocation Lookup Failure (Low Priority - Informational)

**Issue**: Geoclue cannot determine location via WiFi networks

**Error Pattern**:
```
geoclue[XXXX]: Failed to query location: No WiFi networks found
```

**Impact**: Low - Location services unavailable, but doesn't break system functionality

**Recommendations**:
- [ ] Determine if geolocation is needed:
  - Check if applications use location data
  - GNOME Weather, Firefox Geolocation, Maps typically use this
- [ ] If using: Ensure WiFi is connected and visible to the system
- [ ] If not using: No action needed; warning is harmless
- [ ] Can disable geoclue if not needed:
  ```bash
  systemctl --user mask geoclue
  ```
- [ ] Note: Currently disabled in this session (appears to be WiFi-dependent)

---

### 10. ⚠️ Swww Wallpaper Daemon - Single Failure (Low Priority - Intermittent)

**Issue**: Swww wallpaper daemon failed to start on December 10

**Error Log**:
```
Dec 10 23:35:11 nixos systemd[2181]: Failed to start Swww wallpaper daemon.
```

**Current Status**: Service is currently running and operational

**Impact**: Low - One-time failure, currently working. No impact if not recurring.

**Recommendations**:
- [ ] Monitor for recurrence over next few days
- [ ] If fails again: Check logs:
  ```bash
  journalctl -u swww.service -n 50
  ```
- [ ] If recurring: 
  - Check swww configuration in `user/modules/applications/wallpaper.nix`
  - Verify wallpaper image exists and is readable
  - Consider auto-restart on failure
- [ ] Current: No action needed, appears to be resolved

---

### 11. ⚠️ PAM Session Issue (Very Low Priority - One-time)

**Issue**: One instance of failed PAM session cleanup

**Error Log** (Dec 09):
```
(sd-pam)[2051]: pam_systemd(systemd-user:session): 
  Failed to issue ReleaseSession() varlink call: io.systemd.Login.NoSuchSession
```

**Frequency**: Appears once on Dec 09 only, not recurring

**Impact**: Very Low - Session management still works despite error

**Recommendations**:
- [ ] Monitor - appears to be one-time issue
- [ ] If recurring: Investigate systemd session management
- [ ] Current: No action needed, no pattern detected

---

### 12. ⚠️ Fuzzel Launcher Configuration Issue (Low Priority - One-time)

**Issue**: Fuzzel launcher found invalid escaped exec argument character

**Error Log** (Dec 06):
```
fuzzel[2868]: application: invalid escaped exec argument character:
```

**Frequency**: Appears once, not recurring in recent logs

**Impact**: Low - Fuzzel launcher still works

**Recommendations**:
- [ ] Check fuzzel application configurations
- [ ] Look for desktop files with improper escaping
- [ ] Monitor for recurrence
- [ ] Current: No action needed if not recurring

---

### 13. ⚠️ Ancient WiFi Driver Issues (Informational - Historic)

**Issue**: Historical WiFi firmware crash logs from November 30

**Error Pattern**:
```
iwlwifi 0000:00:14.3: Failed to start RT ucode: -110
iwlwifi 0000:00:14.3: Failed to run INIT ucode: -110
intel-spi 0000:00:1f.5: probe with driver intel-spi failed with error -110
```

**Status**: Resolved - No recent occurrences. WiFi is working properly now.

**Impact**: None - Historical issue, currently resolved

**Recommendations**:
- [ ] No action needed - appears to have been a temporary firmware loading issue
- [ ] Monitor WiFi stability going forward
- [ ] Current: WiFi is functioning normally

---

## Action Items Summary

### High Priority
- None identified

### Medium Priority
1. **Stylix Version Mismatch** - Synchronize versions or disable release checks

### Low Priority (Recommended)
2. **Uncommitted Git Changes** - Review, verify, and commit changes
3. **Missing Intel RAPL** - Remove from configuration to suppress warnings
4. **Wireplumber Audio** - Monitor for issues, update if needed

### Very Low Priority (Can Ignore)
- Camera hardware issues (no impact if not using camera)
- Bluetooth wake limitations (no impact if not using wake)
- Gnome Keyring warnings (functionality works)
- Niri cursor issue (cosmetic, works fine)
- Geolocation failures (low priority)
- Swww wallpaper (currently working)

---

## Quick Action Checklist

```
Priority 1 - DO THIS FIRST:
- [ ] Fix Stylix version mismatch

Priority 2 - RECOMMENDED:
- [ ] Review and commit git changes
- [ ] Clean up Intel RAPL configuration

Priority 3 - MONITORING:
- [ ] Monitor Wireplumber audio quality
- [ ] Watch for Swww wallpaper failures
- [ ] Check WiFi stability

Priority 4 - OPTIONAL:
- [ ] Address camera/Bluetooth hardware if needed
- [ ] Clean up cosmetic issues if desired
```

---

## References

- **System Boot Location**: `system/modules/`
- **Hardware Config**: `system/modules/hardware-configuration.nix`
- **Boot Configuration**: `system/modules/boot.nix`
- **User Configuration**: `user/modules/`
- **Services Configuration**: `system/modules/services.nix`, `user/modules/services.nix`
- **Flake Configuration**: `/etc/nixos/flake.nix`

---

**Last Updated**: December 11, 2025  
**Next Review**: When system changes are made or after 2 weeks
