set shell := ["bash", "-c"]

# Run statix linter on all .nix files
lint:
    statix check .

# Format all .nix files with nixpkgs-fmt
fmt:
    find . -name "*.nix" -type f ! -path "./.direnv/*" ! -path "./result/*" -print0 | \
        xargs -0 nixpkgs-fmt

# Run linter and formatter checks (non-destructive)
check: lint
    @echo ""
    @echo "✓ Lint check passed"
    @echo ""
    @echo "Running formatter check (dry-run)..."
    find . -name "*.nix" -type f ! -path "./.direnv/*" ! -path "./result/*" | \
        while read file; do \
            if ! nixpkgs-fmt --check "$$file" 2>/dev/null; then \
                echo "  ⚠️  Would format: $$file"; \
            fi; \
        done || true
    @echo "✓ Format check complete (use 'just fmt' to apply changes)"

# Rebuild NixOS config and switch to new generation
rebuild-switch:
    sudo nixos-rebuild switch --flake .

# Rebuild NixOS config without switching
rebuild-test:
    sudo nixos-rebuild build --flake .

# Update all flake inputs to latest versions
flake-update:
    nix flake update

# Safe garbage collection (removes unreachable store paths)
garbage-collect:
    sudo nix-collect-garbage -d
