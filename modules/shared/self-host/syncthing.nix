{user, ...}: {
  services.syncthing = {
    enable = true;
    user = "${user.name}";
    dataDir = "${user.home}/Documents"; # Default folder for new synced folders
    configDir = "${user.home}/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
  };
}
