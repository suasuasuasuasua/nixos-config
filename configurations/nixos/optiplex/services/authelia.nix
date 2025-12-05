# Authelia provides SSO and authentication for services
# https://www.authelia.com/
# https://wiki.nixos.org/wiki/Authelia
{
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "authelia";

  # Default port for Authelia
  port = 9091;
in
{
  services.authelia.instances.main = {
    enable = true;

    secrets = {
      jwtSecretFile = config.sops.secrets."authelia/jwt_secret".path;
      storageEncryptionKeyFile = config.sops.secrets."authelia/storage_encryption_key".path;
      sessionSecretFile = config.sops.secrets."authelia/session_secret".path;
    };

    settings = {
      theme = "auto";
      
      server = {
        address = "tcp://127.0.0.1:${toString port}";
      };

      log = {
        level = "info";
        format = "text";
      };

      # Use local file-based user database
      # For production, consider LDAP or other backends
      authentication_backend = {
        file = {
          path = "/var/lib/authelia-main/users_database.yml";
          password = {
            algorithm = "argon2";
            argon2 = {
              variant = "argon2id";
              iterations = 3;
              memory = 65536;
              parallelism = 4;
              key_length = 32;
              salt_length = 16;
            };
          };
        };
      };

      session = {
        name = "authelia_session";
        domain = domain;
        expiration = "1h"; # 1 hour
        inactivity = "5m"; # 5 minutes
        remember_me = "1M"; # 1 Month
      };

      storage = {
        local = {
          path = "/var/lib/authelia-main/db.sqlite3";
        };
      };

      notifier = {
        # For production, configure SMTP
        # For now, use filesystem notifier for testing
        filesystem = {
          filename = "/var/lib/authelia-main/notification.txt";
        };
      };

      # Access control rules
      # Default policy is deny, then allow specific rules
      access_control = {
        default_policy = "deny";
        
        rules = [
          # Allow access to Authelia itself
          {
            domain = "${serviceName}.${domain}";
            policy = "bypass";
          }
          # Example: require authentication for protected services
          # Uncomment and modify as needed
          # {
          #   domain = "*.${domain}";
          #   policy = "two_factor";
          # }
        ];
      };

      # Identity providers configuration for SSO
      # Uncomment and configure when you want to use Authelia as an OIDC provider
      # identity_providers = {
      #   oidc = {
      #     # HMAC secret for OIDC - add to secrets if needed
      #     # hmac_secret will be read from secrets file
      #     
      #     # Issuer private key - generate RSA key and add to secrets
      #     # issuer_private_key will be read from secrets file
      #
      #     # Clients will be configured here for apps like Gitea
      #     clients = [
      #       # Example client configuration
      #       # {
      #       #   client_id = "gitea";
      #       #   client_name = "Gitea";
      #       #   client_secret = "$argon2id$..."; # Hashed secret
      #       #   public = false;
      #       #   authorization_policy = "two_factor";
      #       #   redirect_uris = [ "https://gitea.${domain}/user/oauth2/authelia/callback" ];
      #       #   scopes = [
      #       #     "openid"
      #       #     "profile"
      #       #     "email"
      #       #     "groups"
      #       #   ];
      #       # }
      #     ];
      #   };
      # };
    };
  };

  # Configure secrets
  sops.secrets = {
    "authelia/jwt_secret" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
      owner = "authelia-main";
      group = "authelia-main";
    };
    "authelia/storage_encryption_key" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
      owner = "authelia-main";
      group = "authelia-main";
    };
    "authelia/session_secret" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
      owner = "authelia-main";
      group = "authelia-main";
    };
  };

  # Configure Nginx reverse proxy
  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $http_host;
        '';
      };

      serverAliases = [
        "${serviceName}.${hostName}.${domain}"
      ];
    };

    # Authentication endpoint for other services
    "auth.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      
      locations."/api/verify" = {
        proxyPass = "http://127.0.0.1:${toString port}/api/verify";
        extraConfig = ''
          internal;
        '';
      };

      serverAliases = [
        "auth.${hostName}.${domain}"
      ];
    };
  };
}
