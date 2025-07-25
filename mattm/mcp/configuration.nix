{ config, pkgs, ... }:

{
  # MCP Server configuration for Cline
  # This creates the MCP settings file in the proper location
  
  home.file.".config/VSCodium/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json" = {
    text = builtins.toJSON {
      mcpServers = {
        test-server = {
          command = "${pkgs.bun}/bin/bun";
          args = [ "/etc/nixos/mattm/mcp/test-server/src/index.ts" ];
          disabled = false;
          autoApprove = [];
        };
      };
    };
  };

  # Also create a symlink to the MCP directory for easy access
  home.file.".local/share/mcp-servers" = {
    source = ./test-server;
    recursive = true;
  };
}
