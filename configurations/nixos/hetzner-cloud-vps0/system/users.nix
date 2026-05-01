{
  config,
  inputs,
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

  users.users.admin = {
    hashedPasswordFile = admin_password;
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBse2Ikd1n7K9MnQiXmC4kNdNOasAVBbgH01pozcsbm justinhoang@Justins-MacBook-Pro.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIj5A33KUdeHGh1q0/yql45KfdW0+byou1c0XRdPWrmQ gitea.deployment"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5vx5WQe2m2fXDFhjnNeYYrY6OIR0y5X0nfdAAlchcl justinhoang@lab"
    ];
  };

  # Require sudo for wheel group
  security.sudo.wheelNeedsPassword = true;
}
