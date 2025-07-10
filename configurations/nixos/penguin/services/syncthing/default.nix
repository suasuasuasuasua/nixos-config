# syncthing is a lightweight decentralized synchronization server
let
  # default = 8384
  port = 8384;
  settings = import ./settings.nix;

  # allow syncthing to interact with the user home directory
  dataDir = "/home/justinhoang";
  group = "users";
  user = "justinhoang";
in
{
  users.users.syncthing = {
    isSystemUser = true;
    group = "syncthing";
    extraGroups = [ "samba" ];
  };
  users.groups.syncthing = { };

  services.syncthing = {
    inherit
      dataDir
      group
      user
      settings
      ;

    enable = true;

    # 0.0.0.0 for debugging from web gui
    guiAddress = "127.0.0.1:${toString port}";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
  };

  # https://wiki.nixos.org/wiki/Syncthing#Disable_default_sync_folder
  # don't create the default folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}
