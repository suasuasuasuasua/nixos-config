# jellyfin is a self hosted media server
{
  config,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "jellyfin";

  # default = 8096
  port = 8096;
in
{
  users.users.jellyfin.extraGroups = [ "samba" ];

  services.jellyfin = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
