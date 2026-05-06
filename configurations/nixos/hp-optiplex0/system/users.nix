{
  config,
  inputs,
  pkgs,
  users,
  ...
}:
let
  admin_password = config.sops.secrets."passwords/admin".path;
  justinhoang_password = config.sops.secrets."passwords/justinhoang".path;
in
{
  programs.zsh.enable = true;

  sops.secrets = {
    "passwords/admin" = {
      neededForUsers = true;
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "passwords/justinhoang" = {
      neededForUsers = true;
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  users.users = {
    admin = {
      hashedPasswordFile = admin_password;
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      openssh.authorizedKeys.keys = with users.justinhoang.sshKeys; [
        mbp
        lab
      ];
    };
    justinhoang = {
      hashedPasswordFile = justinhoang_password;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = with users.justinhoang.sshKeys; [
        iphone15
        mbp
        ilmgf
        fedora
        ipadProM2
      ];
    };
  };

  # Require sudo for wheel group
  security.sudo.wheelNeedsPassword = true;
}
