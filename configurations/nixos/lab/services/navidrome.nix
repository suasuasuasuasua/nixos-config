# navidrome is a self hosted music server
{
  config,
  inputs,
  infra,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "navidrome";

  MusicFolder = "/zshare/media/music";
  environmentFile = config.sops.secrets."navidrome/environment".path;
in
{
  services.navidrome = {
    inherit environmentFile;
    enable = true;

    settings = {
      inherit MusicFolder;

      Address = "127.0.0.1";
      Port = infra.ports.navidrome;
      EnableInsightsCollector = false;
    };
  };

  users.users.navidrome.extraGroups = [ "samba" ];

  sops.secrets = {
    "navidrome/environment" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.navidrome}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
