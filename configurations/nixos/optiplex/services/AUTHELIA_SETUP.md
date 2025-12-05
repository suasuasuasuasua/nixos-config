# Authelia SSO Setup Guide

Authelia provides Single Sign-On (SSO) authentication for your services. This guide explains how to set up and use Authelia for SSO.

## What is Authelia?

Authelia is an open-source authentication and authorization server that provides:
- **Single Sign-On (SSO)**: Log in once, access multiple services
- **Two-Factor Authentication (2FA)**: Support for TOTP, WebAuthn, and more
- **OIDC/OAuth2 Provider**: Integrate with apps that support OAuth/OIDC
- **Forward Authentication**: Protect services via reverse proxy

## Initial Setup

### 1. Generate Secrets

Before deploying Authelia, you need to generate secure secrets. Use these commands:

```bash
# Generate JWT secret (64 characters recommended)
openssl rand -hex 32

# Generate storage encryption key (64 characters recommended)
openssl rand -hex 32

# Generate session secret (64 characters recommended)
openssl rand -hex 32
```

### 2. Add Secrets to SOPS

Add the generated secrets to your `secrets/secrets.yaml` file:

```yaml
authelia:
  jwt_secret: <generated-jwt-secret>
  storage_encryption_key: <generated-storage-encryption-key>
  session_secret: <generated-session-secret>
```

Then encrypt the secrets file:

```bash
sops -e -i secrets/secrets.yaml
```

### 3. Create Users

Create a user database file at `/var/lib/authelia-main/users_database.yml` on your server.

First, generate a password hash using one of these methods:

**Method 1: Using Docker** (easiest if you have Docker installed)
```bash
docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password 'YourPasswordHere'
```

**Method 2: Using Authelia on NixOS** (after deploying the module)
```bash
# SSH into your server after deploying Authelia
authelia crypto hash generate argon2 --password 'YourPasswordHere'
```

**Method 3: Using Python** (no external dependencies)
```bash
# Install argon2-cffi if not available
nix-shell -p python3Packages.argon2-cffi --run "python3 -c \"
import argon2
ph = argon2.PasswordHasher(
    time_cost=3,
    memory_cost=65536,
    parallelism=4,
    hash_len=32,
    salt_len=16
)
print(ph.hash('YourPasswordHere'))
\""
```

Then create the users file:

```yaml
users:
  admin:
    displayname: "Admin User"
    password: "$argon2id$v=19$m=65536,t=3,p=4$..." # Use the hash generated above
    email: admin@example.com
    groups:
      - admins
      - users
  
  user:
    displayname: "Regular User"
    password: "$argon2id$v=19$m=65536,t=3,p=4$..." # Different hash
    email: user@example.com
    groups:
      - users
```

### 4. Deploy and Access

After deploying the configuration:

1. Rebuild your NixOS system: `nixos-rebuild switch`
2. Access Authelia at: `https://authelia.yourdomain.com`
3. Log in with the credentials you created

## Protecting Services with Forward Authentication

To protect a service using Authelia's forward authentication:

### Example: Protecting Glances

Edit the service's nginx configuration:

```nix
services.nginx.virtualHosts."glances.${domain}" = {
  enableACME = true;
  forceSSL = true;
  acmeRoot = null;
  
  # Add authentication
  locations."/" = {
    proxyPass = "http://127.0.0.1:${toString cfg.port}";
    
    # Forward authentication to Authelia
    extraConfig = ''
      auth_request /authelia;
      auth_request_set $user $upstream_http_remote_user;
      auth_request_set $groups $upstream_http_remote_groups;
      auth_request_set $name $upstream_http_remote_name;
      auth_request_set $email $upstream_http_remote_email;
      
      proxy_set_header Remote-User $user;
      proxy_set_header Remote-Groups $groups;
      proxy_set_header Remote-Name $name;
      proxy_set_header Remote-Email $email;
    '';
  };
  
  # Authelia auth endpoint
  locations."/authelia" = {
    proxyPass = "http://127.0.0.1:9091/api/verify";
    extraConfig = ''
      internal;
      proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
      proxy_set_header X-Forwarded-Method $request_method;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-Host $http_host;
      proxy_set_header X-Forwarded-URI $request_uri;
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header Content-Length "";
      proxy_set_header Connection "";
      
      proxy_pass_request_body off;
    '';
  };
};
```

Then update the access control rules in `authelia.nix`:

```nix
access_control = {
  default_policy = "deny";
  
  rules = [
    {
      domain = "authelia.${domain}";
      policy = "bypass";
    }
    {
      domain = "glances.${domain}";
      policy = "two_factor";  # or "one_factor"
    }
  ];
};
```

## Using Authelia as an OIDC Provider for SSO

Authelia can act as an OAuth2/OIDC provider for applications like Gitea, Grafana, etc.

**Note**: OIDC configuration is currently commented out in `authelia.nix`. To enable it, you need to:

1. Generate OIDC secrets (HMAC secret and RSA private key)
2. Add them to your secrets file
3. Uncomment and configure the `identity_providers.oidc` section in `authelia.nix`

### Example: Configure Gitea with Authelia SSO

#### 0. Enable OIDC in Authelia

First, uncomment the OIDC section in `authelia.nix` and add the required secrets.

Generate an RSA private key for OIDC:

```bash
# Generate RSA private key
openssl genrsa -out /tmp/authelia-oidc-key.pem 4096

# Add to secrets/secrets.yaml:
# authelia_oidc:
#   hmac_secret: <generated with openssl rand -hex 32>
#   issuer_private_key: |
#     <contents of authelia-oidc-key.pem>
```

#### 1. Generate a Client Secret

```bash
# Generate a random client secret
openssl rand -hex 32

# Hash it for Authelia
docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password 'your-client-secret-here'
```

#### 2. Configure Authelia Client

Uncomment the OIDC section in `authelia.nix` and add your client configuration:

```nix
clients = [
  {
    client_id = "gitea";
    client_name = "Gitea";
    client_secret = "$argon2id$v=19$m=65536,t=3,p=4$..."; # Hashed secret from step 1
    public = false;
    authorization_policy = "two_factor";
    redirect_uris = [
      "https://gitea.yourdomain.com/user/oauth2/authelia/callback"
    ];
    scopes = [
      "openid"
      "profile"
      "email"
      "groups"
    ];
    userinfo_signed_response_alg = "none";
  }
];
```

#### 3. Configure Gitea

In Gitea's admin panel (Site Administration → Authentication Sources):

1. Click "Add Authentication Source"
2. Select "OAuth2" as the authentication type
3. Fill in:
   - **Authentication Name**: Authelia
   - **OAuth2 Provider**: OpenID Connect
   - **Client ID**: `gitea`
   - **Client Secret**: The unhashed secret from step 1
   - **OpenID Connect Auto Discovery URL**: `https://authelia.yourdomain.com/.well-known/openid-configuration`
   - **Icon URL**: (optional) `https://www.authelia.com/images/branding/logo-cropped.png`
4. Save the configuration

#### 4. Test SSO Login

1. Log out of Gitea
2. On the login page, you should see "Sign in with Authelia"
3. Click it and you'll be redirected to Authelia
4. After authenticating, you'll be redirected back to Gitea and logged in

### Other Services That Support OIDC

Many services support OIDC/OAuth2 authentication:
- **Grafana**: Configure OAuth in `configuration.nix`
- **Immich**: Add OIDC provider in settings
- **Vaultwarden**: Configure SSO via environment variables
- **Home Assistant**: Add Authelia as an authentication provider

## Access Control Policies

Authelia supports different authentication policies:

- **bypass**: No authentication required
- **one_factor**: Username + password only
- **two_factor**: Username + password + 2FA (TOTP, WebAuthn, etc.)
- **deny**: Explicitly deny access

Example access control configuration:

```nix
access_control = {
  default_policy = "deny";
  
  rules = [
    # Public services (no auth)
    {
      domain = "authelia.${domain}";
      policy = "bypass";
    }
    
    # Admin-only services (2FA required)
    {
      domain = "admin.${domain}";
      policy = "two_factor";
      subject = [ "group:admins" ];
    }
    
    # User services (password only)
    {
      domain = "*.${domain}";
      policy = "one_factor";
    }
  ];
};
```

## Setting Up 2FA

After logging in to Authelia for the first time:

1. Click on your profile icon
2. Select "Two-Factor Authentication"
3. Choose a method:
   - **Time-based One-Time Password (TOTP)**: Use apps like Google Authenticator, Authy, or 1Password
   - **Security Key**: Use hardware keys like YubiKey
4. Follow the setup wizard

## Troubleshooting

### Cannot access Authelia web interface
- Check if the service is running: `systemctl status authelia-main.service`
- Check logs: `journalctl -u authelia-main.service -f`
- Verify DNS is configured to point to your server
- Check firewall rules allow ports 80 and 443

### Authentication loop on protected service
- Verify the service domain is in the access control rules
- Check nginx configuration has correct auth_request directives
- Review Authelia logs for errors

### OIDC client not working
- Verify redirect URIs match exactly
- Check client secret is correctly hashed in Authelia config
- Ensure the OpenID Connect discovery URL is accessible
- Review both Authelia and application logs

### Users cannot log in
- Verify user exists in `users_database.yml`
- Check password hash is correct format (argon2id)
- Ensure file permissions are correct: `chown authelia-main:authelia-main /var/lib/authelia-main/users_database.yml`

## Additional Resources

- [Authelia Documentation](https://www.authelia.com/docs/)
- [OIDC Integration Guides](https://www.authelia.com/integration/openid-connect/introduction/)
- [Access Control Configuration](https://www.authelia.com/configuration/security/access-control/)
- [NixOS Authelia Options](https://search.nixos.org/options?query=services.authelia)

## Security Best Practices

1. **Always use HTTPS**: Ensure all services use SSL/TLS certificates
2. **Strong Secrets**: Use cryptographically secure random strings for all secrets
3. **Regular Updates**: Keep Authelia and NixOS packages updated
4. **Backup**: Regularly backup `/var/lib/authelia-main/` directory
5. **Least Privilege**: Use group-based access control to limit service access
6. **Enable 2FA**: Require two-factor authentication for sensitive services
7. **Monitor Logs**: Regularly review authentication logs for suspicious activity
