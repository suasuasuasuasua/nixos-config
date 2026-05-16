# https://wiki.nixos.org/wiki/Uptime_Kuma
{
  config,
  infra,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "uptime-kuma";
  statusIndex = pkgs.writeTextDir "index.html" (builtins.readFile ./uptime-kuma-status-index.html);
in
{
  services.uptime-kuma = {
    enable = true;

    appriseSupport = true;
    settings.UPTIME_KUMA_PORT = toString infra.ports.uptime-kuma;
  };

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations = {
      "= /status/" = {
        root = "${statusIndex}";
        index = "index.html";
        extraConfig = "try_files /index.html =404;";
      };
      "/" = {
        proxyPass = "http://localhost:${toString infra.ports.uptime-kuma}";
        proxyWebsockets = true;
      };
    };

    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
