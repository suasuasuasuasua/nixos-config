{
  config,
  inputs,
  pkgs,
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

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA12qTb88TMH/x1T2xST2kEviP+RGGQkv+EJFWPboxuv justinhoang@iphone15"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBse2Ikd1n7K9MnQiXmC4kNdNOasAVBbgH01pozcsbm justinhoang@Justins-MacBook-Pro.local"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUijrS7uoSrbIA/R1EmnvzU7xcv6h8u+RVYBU9Ruw31 justinhoang@ilmgf"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILBclQTbAA8JkwD5mV17zhuISaF5t6vliyOsEaRdMpsw justinhoang@fedora"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSeaDq9Cb9lhnEPP6SHAJ8pJ2TPiF/y8hXpJtvsSCMk justinhoang@ipadProM2"
      ];
    };
    katelynjascha = {
      hashedPasswordFile = katelyn_password;

      isNormalUser = true;
      extraGroups = [ "samba" ];
      shell = pkgs.zsh;
    };
  };
}
