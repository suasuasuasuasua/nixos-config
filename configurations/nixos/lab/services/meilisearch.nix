{
  inputs,
  config,
  pkgs,
  ...
}:
let
  # default = 7700
  port = 7700;
  masterKeyFile = config.sops.secrets."meilisearch/masterKeyFile".path;
in
{
  sops.secrets = {
    "meilisearch/masterKeyFile" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  services.meilisearch = {
    inherit masterKeyFile;

    enable = true;
    package = pkgs.meilisearch;

    listenPort = port;
    listenAddress = "127.0.0.1";
  };
}
