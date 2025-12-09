# Example: Gitea with Authelia OIDC SSO Integration
#
# This file demonstrates how to configure Gitea to use Authelia for SSO.
# To enable, add the OIDC configuration to your gitea.nix settings.
#
# NOTE: This is an EXAMPLE file. Do not import this directly.
# Instead, copy the relevant sections to your actual gitea.nix configuration.

{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "gitea";
  
  stateDir = "/zshare/srv/gitea";
  tokenFile = config.sops.secrets."gitea/token".path;
  
  port = 3001;
in
{
  services = {
    gitea = {
      inherit stateDir;
      
      enable = true;
      lfs.enable = true;
      
      settings = {
        server = {
          DOMAIN = "${serviceName}.${domain}";
          HTTP_PORT = port;
          ROOT_URL = "https://${serviceName}.${domain}";
        };
        service = {
          DISABLE_REGISTRATION = true;
        };
        session = {
          COOKIE_SECURE = true;
        };
        
        # Add OAuth2 configuration for Authelia
        # NOTE: You'll also need to configure this in Gitea's web interface
        # Site Administration -> Authentication Sources -> Add OAuth2 Source
        #
        # Alternatively, you can use Gitea's CLI or configuration file.
        # Here's how to set it up via the web interface:
        #
        # 1. Log in as an admin
        # 2. Go to Site Administration
        # 3. Click "Authentication Sources"
        # 4. Click "Add Authentication Source"
        # 5. Fill in:
        #    - Authentication Type: OAuth2
        #    - Name: Authelia
        #    - OAuth2 Provider: OpenID Connect
        #    - Client ID: gitea (must match Authelia config)
        #    - Client Secret: <your-unhashed-client-secret>
        #    - OpenID Connect Auto Discovery URL: https://authelia.yourdomain.com/.well-known/openid-configuration
        #
        # OR use database.path to configure via SQL/config file (advanced)
      };
    };
  };
  
  # Example: Configure Authelia OIDC client for Gitea
  # Add this to your authelia.nix configuration:
  #
  # identity_providers.oidc.clients = [
  #   {
  #     client_id = "gitea";
  #     client_name = "Gitea";
  #     client_secret = "$argon2id$v=19$m=65536,t=3,p=4$..."; # Hashed secret
  #     public = false;
  #     authorization_policy = "two_factor";
  #     redirect_uris = [
  #       "https://gitea.yourdomain.com/user/oauth2/authelia/callback"
  #     ];
  #     scopes = [
  #       "openid"
  #       "profile"
  #       "email"
  #       "groups"
  #     ];
  #     userinfo_signed_response_alg = "none";
  #   }
  # ];
  
  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
        
        extraConfig = "client_max_body_size 0;";
      };
      
      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
