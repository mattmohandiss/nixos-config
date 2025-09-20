# TODO

## ⚙️ Configuration Tasks

### Consider Browser Configuration Consolidation
Firefox and Zen Browser have nearly identical configurations. Consider if you need both browsers or if configs can be consolidated to reduce maintenance.

## 🖥️ Hardware & Firmware

### Configure External Monitor Setup
Set up external monitor configuration for docking/undocking workflows to improve productivity when using external displays.

## 🔒 Security & Maintenance

### Set Up Automatic System Updates
Configure automatic system updates and maintenance schedule to keep the system secure and up-to-date.

### Configure Backup Strategy
Set up backup strategy for `/etc/nixos` configuration and home directory to prevent data loss.

### Set Up Nix Garbage Collection
Configure automatic Nix garbage collection schedule to manage disk space and remove old system generations.

### Review SSH Configuration
Review and harden SSH configuration for better security if SSH access is needed.

### Configure Automatic Security Updates
Set up automatic security updates to ensure critical security patches are applied promptly.

## 🎨 User Experience

### Configure Notification System
Set up and configure the notification system (mako is installed but may need configuration) for better desktop experience.

### Consider Pawbar Alternative
Evaluate using pawbar instead of waybar for the status bar as mentioned in original TODO.

### Improve Script Organization and Dependencies
Consider moving scripts from `/etc/nixos/mattm/scripts` to a proper bin directory in the user's PATH for better organization. Verify that all wallpaper and other scripts have proper dependency declarations and error handling.

### Add Documentation Comments
Add comments to complex configurations (especially Surface Pro kernel parameters) explaining why each setting is needed for future reference.

### Document MCP Server Setup
Add documentation for the MCP test server configuration and consider expansion if more MCP tools are planned. The current setup in `mattm/mcp/configuration.nix` could benefit from usage examples and development guidelines.
