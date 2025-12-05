# Authelia SSO Authentication

Authelia provides Single Sign-On (SSO) and authentication for services on the lab server.

## Files in this directory

- `default.nix` - Main Authelia service configuration
- `SETUP.md` - Complete setup guide with step-by-step instructions
- `secrets-template.yaml` - Template for required secrets
- `protected-services-example.nix` - Examples for protecting services with forward auth
- `gitea-oidc-example.nix` - Example for Gitea OIDC/OAuth2 integration

## Quick Start

See [SETUP.md](./SETUP.md) for detailed setup instructions.

## Features

- **Single Sign-On (SSO)**: Log in once, access multiple services
- **Two-Factor Authentication (2FA)**: Support for TOTP, WebAuthn, and more
- **OIDC/OAuth2 Provider**: Integrate with apps that support OAuth/OIDC
- **Forward Authentication**: Protect services via reverse proxy

## Port

- 9091 (Authelia web interface and API)
