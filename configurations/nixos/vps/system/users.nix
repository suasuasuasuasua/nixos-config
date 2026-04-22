{
  config,
  inputs,
  pkgs,
  ...
}:
let
  admin_password = config.sops.secrets."passwords/admin".path;
in
{
  sops.secrets = {
    "passwords/admin" = {
      neededForUsers = true;
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  # Need to enable zsh before we can actually use it. Home manager configs it,
  # but cannot set the login shell because that's root level operation
  programs.zsh.enable = true;

  users.users.admin = {
    hashedPasswordFile = admin_password;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBse2Ikd1n7K9MnQiXmC4kNdNOasAVBbgH01pozcsbm justinhoang@Justins-MacBook-Pro.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5vx5WQe2m2fXDFhjnNeYYrY6OIR0y5X0nfdAAlchcl justinhoang@lab"
    ];
  };

  # Require sudo for wheel group
  security.sudo.wheelNeedsPassword = true;
}
