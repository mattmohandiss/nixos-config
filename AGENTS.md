# NixOS Repository Instructions

## Scope

- This repository is the declarative source of truth for the Surface NixOS system and Home Manager configuration.
- Follow the global OpenCode guidance for workflow, safety, and validation.
- Keep machine configuration in Nix; do not hand-edit generated profiles, Home Manager files, or symlink targets.

## Structure

- `flake.nix` defines the system entry point and pinned inputs.
- `modules/system/` contains NixOS modules.
- `modules/home/` contains Home Manager modules.
- `pkgs/` contains locally packaged software.
- `scripts/` contains repository-owned user scripts.

## Commands

- Check available recipes with `just --list`.
- Use `just build` to evaluate and build the system configuration.
- Use `just switch` to activate a validated configuration.
- Use `just lint` for Nix formatting and static checks.

## Change Rules

- Prefer declarative Nix changes over imperative setup commands.
- Keep project-specific language tools in project flakes under `~/Code`; keep global packages limited to shared workstation tools.
- Treat `~/.config/opencode` as generated from `modules/home/dev/opencode`.
- Never commit API keys, tokens, passwords, or machine-local credentials.
- Preserve unrelated worktree changes and do not use destructive Git commands without explicit approval.

<!-- lean-ctx -->
## lean-ctx

lean-ctx is active — the MCP tools replace native equivalents.
Full rules: LEAN-CTX.md (open on demand — do not auto-load).
<!-- /lean-ctx -->
