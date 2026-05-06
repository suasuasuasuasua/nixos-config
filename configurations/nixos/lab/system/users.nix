{
  config,
  inputs,
  pkgs,
  users,
  ...
}:
let
  justinhoang_password = config.sops.secrets."passwords/justinhoang".path;
  katelyn_password = config.sops.secrets."passwords/katelynjascha".path;
in
{
  # Need to enable zsh before we can actually use it. Home manager configs it,
  # but cannot set the login shell because that's root level operation
  programs.zsh.enable = true;

  sops.secrets = {
    "passwords/justinhoang" = {
      neededForUsers = true;
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "passwords/katelynjascha" = {
      neededForUsers = true;
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  users.users = {
    justinhoang = {
      hashedPasswordFile = justinhoang_password;

      isNormalUser = true;
      extraGroups = [
        "libvirtd"
        "minecraft"
        "samba"
        "syncthing"
        "wheel"
      ];
      shell = pkgs.zsh;

      openssh.authorizedKeys.keys = with users.justinhoang.sshKeys; [
        iphone15
        mbp
        ilmgf
        fedora
        ipadProM2
      ];
    };
    katelynjascha = {
      hashedPasswordFile = katelyn_password;

      isNormalUser = true;
      extraGroups = [ "samba" ];
      shell = pkgs.zsh;
    };
  };

  # # NOTE: may be required on first load due to sops chicken and egg problem
  # security.sudo.wheelNeedsPassword = false;
}
