# Services

## Ports

- 22 (ssh)
- 80 (nginx)
- 443 (nginx)
- 3000 (adguard home)
- 4000 (uptime kuma)
- 5353 (avahi)
- 9091 (authelia)
- 61208 (glances)

## Authentication

The server uses [Authelia](https://www.authelia.com/) for SSO (Single Sign-On) authentication.

- **Setup Guide**: See [AUTHELIA_SETUP.md](./AUTHELIA_SETUP.md) for complete setup instructions
- **Configuration**: [authelia.nix](./authelia.nix)
- **Examples**:
  - [Protecting services with forward auth](./authelia-protected-services-example.nix)
  - [Gitea OIDC integration](./gitea-authelia-example.nix)

Authelia provides:
- Single Sign-On (SSO) across all services
- Two-Factor Authentication (2FA)
- OAuth2/OIDC provider for compatible applications
- Fine-grained access control policies
