# https://wiki.nixos.org/wiki/Jellyfin
# jellyfin is a self hosted media server
{
  config,
  pkgs,
  infra,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "jellyfin";
in
{
  services.jellyfin.enable = true;

  users.users.jellyfin.extraGroups = [ "samba" ];

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/".proxyPass = "http://127.0.0.1:${toString infra.ports.jellyfin}";

    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
