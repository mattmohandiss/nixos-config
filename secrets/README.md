# Secrets

Encrypted secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix)
and age. The encrypted files in this directory are safe to commit; age private
keys must remain outside the repository.

The Surface configuration expects the age identity at:

```text
/home/mattm/.config/sops/age/keys.txt
```

Back up that file securely. It is required to decrypt or update the encrypted
secrets.
