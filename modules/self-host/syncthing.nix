{user, ...}: let
  name = "syncthing";
  host = "localhost";
  port = "8384";
in {
  services.syncthing = {
    enable = true;
    user = "${user.name}";
    dataDir = "${user.home}/Documents"; # Default folder for new synced folders
    configDir = "${user.home}/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
  };

  services.nginx.virtualHosts."${name}.local" = {
    locations."/" = {
      proxyPass = "http://${host}:${port}/";
    };
  };
}
