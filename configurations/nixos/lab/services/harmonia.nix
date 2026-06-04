{
  config,
  infra,
  inputs,
  ...
}:
let
  inherit (config.networking) domain;
  serviceName = "cache";
in
{
  sops.secrets."harmonia/signing-key" = {
    sopsFile = "${inputs.self}/secrets/secrets.yaml";
    mode = "0400";
  };

  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [ config.sops.secrets."harmonia/signing-key".path ];
    settings.bind = "127.0.0.1:${toString infra.ports.harmonia}";
  };

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString infra.ports.harmonia}";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_buffering off;
      '';
    };
  };
}
