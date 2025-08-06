# https://wiki.nixos.org/wiki/Syncthing
# syncthing is a lightweight decentralized synchronization server
let
  # default = 8384
  port = 8384;
  settings = import ./settings.nix;
in
{
  services.syncthing = {
    inherit settings;

    enable = true;
    user = "justinhoang";
    group = "samba";
    dataDir = "/zshare/personal/notes/";
    configDir = "/zshare/personal/notes/.config/syncthing";

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
