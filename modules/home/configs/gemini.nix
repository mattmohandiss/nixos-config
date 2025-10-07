{ config, pkgs, ... }:

{
  home.file.".gemini/settings.json".text = '''
    {
      "general": {
        "preferredEditor": "code",
        "checkpointing": {
          "enabled": true
        }
      },
      "ui": {
        "theme": "GitHub",
        "hideBanner": true
      },
      "model": {
        "name": "gemini-1.5-pro-latest",
        "summarizeToolOutput": {
          "run_shell_command": {
            "tokenBudget": 4096
          }
        }
      },
      "tools": {
        "sandbox": "docker",
        "allowed": [
          "run_shell_command(git status)",
          "run_shell_command(git diff)",
          "run_shell_command(ls -la)",
          "run_shell_command(nixos-rebuild switch)"
        ]
      },
      "privacy": {
        "usageStatisticsEnabled": true
      }
    }
  ''';
}
