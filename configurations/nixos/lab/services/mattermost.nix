{
  config,
  infra,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "mattermost";
in
{
  services.mattermost = {
    enable = true;
    siteUrl = "https://${serviceName}.${domain}";
    host = "127.0.0.1";
    port = infra.ports.mattermost.http;

    database = {
      create = true;
      peerAuth = true;
    };

    plugins = [
      (pkgs.fetchurl {
        url = "https://github.com/mattermost/mattermost-plugin-calls/releases/download/v1.11.5/mattermost-plugin-calls-v1.11.5-linux-amd64.tar.gz";
        sha256 = "1j83mvzyfd9hwcnavaka27jdv2nh3zqc3ncafcp4kx0xv2xk88m3";
      })
    ];

    settings = {
      TeamSettings.EnableOpenServer = false;
      ServiceSettings = {
        EnableSignUpWithEmail = false;
        MaximumLoginAttempts = 10;
      };
      RateLimitSettings = {
        Enable = true;
        PerSec = 10;
        MaxBurst = 100;
        MemoryStoreSize = 10000;
      };
      PrivacySettings = {
        ShowEmailAddress = false;
        ShowFullName = false;
      };
    };
  };

  networking.firewall.allowedUDPPorts = [ infra.ports.mattermost.calls ];

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString infra.ports.mattermost.http}";
      proxyWebsockets = true;
    };
    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
