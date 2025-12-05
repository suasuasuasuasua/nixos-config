# Example: Protecting Services with Authelia Forward Authentication
#
# This file shows how to add Authelia authentication to various services.
# Copy and adapt these examples to your service configurations.

{
  config,
  ...
}:
let
  inherit (config.networking) hostName domain;
  
  # Common nginx configuration for Authelia forward auth
  autheliaAuthConfig = ''
    # Forward the request to Authelia for verification
    auth_request /authelia;
    
    # Pass user information from Authelia to the backend service
    auth_request_set $user $upstream_http_remote_user;
    auth_request_set $groups $upstream_http_remote_groups;
    auth_request_set $name $upstream_http_remote_name;
    auth_request_set $email $upstream_http_remote_email;
    
    # Set headers with user information
    proxy_set_header Remote-User $user;
    proxy_set_header Remote-Groups $groups;
    proxy_set_header Remote-Name $name;
    proxy_set_header Remote-Email $email;
  '';
  
  # Authelia verification endpoint configuration
  autheliaVerifyLocation = {
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
in
{
  # Example 1: Protecting Glances with Authelia
  services.nginx.virtualHosts."glances.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    
    locations."/" = {
      proxyPass = "http://127.0.0.1:61208";
      extraConfig = autheliaAuthConfig;
    };
    
    locations."/authelia" = autheliaVerifyLocation;
  };
  
  # Example 2: Protecting Uptime Kuma with Authelia
  services.nginx.virtualHosts."uptime-kuma.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    
    locations."/" = {
      proxyPass = "http://localhost:4000";
      proxyWebsockets = true;
      extraConfig = autheliaAuthConfig;
    };
    
    locations."/authelia" = autheliaVerifyLocation;
  };
  
  # Example 3: Protecting Dashy with Authelia
  services.nginx.virtualHosts."${hostName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    
    # You may want to exclude certain paths from authentication
    # For example, allow public access to some sections:
    locations."/public" = {
      proxyPass = "http://localhost:8080/public";
      # No auth_request here - public access
    };
    
    locations."/" = {
      proxyPass = "http://localhost:8080";
      extraConfig = autheliaAuthConfig;
    };
    
    locations."/authelia" = autheliaVerifyLocation;
  };
  
  # Example 4: Partial protection - only protect admin paths
  services.nginx.virtualHosts."service.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    
    # Protect admin interface
    locations."/admin" = {
      proxyPass = "http://localhost:8000/admin";
      extraConfig = autheliaAuthConfig;
    };
    
    # Allow public access to main service
    locations."/" = {
      proxyPass = "http://localhost:8000";
    };
    
    locations."/authelia" = autheliaVerifyLocation;
  };
  
  # Example 5: Service with specific authentication requirements
  # Update authelia.nix access_control to match:
  #
  # access_control = {
  #   default_policy = "deny";
  #   rules = [
  #     {
  #       domain = "admin-service.${domain}";
  #       policy = "two_factor";
  #       subject = [ "group:admins" ];  # Only admins can access
  #     }
  #   ];
  # };
  services.nginx.virtualHosts."admin-service.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    
    locations."/" = {
      proxyPass = "http://localhost:9000";
      extraConfig = autheliaAuthConfig;
    };
    
    locations."/authelia" = autheliaVerifyLocation;
  };
}

# Additional Notes:
#
# 1. Access Control Configuration in authelia.nix:
#    Don't forget to add the protected domains to Authelia's access control rules:
#
#    access_control = {
#      default_policy = "deny";
#      rules = [
#        {
#          domain = "authelia.${domain}";
#          policy = "bypass";
#        }
#        {
#          domain = "glances.${domain}";
#          policy = "two_factor";
#        }
#        {
#          domain = "uptime-kuma.${domain}";
#          policy = "one_factor";
#        }
#      ];
#    };
#
# 2. WebSocket Support:
#    For services that use WebSockets (like Uptime Kuma), always include:
#    proxyWebsockets = true;
#
# 3. Large File Uploads:
#    For services that handle large files, add:
#    extraConfig = ''
#      ${autheliaAuthConfig}
#      client_max_body_size 0;
#    '';
#
# 4. DNS Configuration:
#    Ensure DNS is configured for all protected services and the auth subdomain:
#    - authelia.yourdomain.com
#    - auth.yourdomain.com (for the verify endpoint)
#    - <service>.yourdomain.com
