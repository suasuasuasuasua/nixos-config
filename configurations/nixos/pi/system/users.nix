{
  config,
  inputs,
  pkgs,
  users,
  ...
}:
let
  admin_password = config.sops.secrets."passwords/admin".path;
in
{
  # Need to enable zsh before we can actually use it. Home manager configs it,
  # but cannot set the login shell because that's root level operation
  programs.zsh.enable = true;

  sops.secrets."passwords/admin" = {
    neededForUsers = true;
    sopsFile = "${inputs.self}/secrets/secrets.yaml";
  };

  users.users.admin = {
    hashedPasswordFile = admin_password;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = with users.justinhoang.sshKeys; [
      iphone15
      mbp
      ilmgf
      fedora
      ipadProM2
      lab
    ];
  };

  # # NOTE: may be required on first load due to sops chicken and egg problem
  # security.sudo.wheelNeedsPassword = false;
}
