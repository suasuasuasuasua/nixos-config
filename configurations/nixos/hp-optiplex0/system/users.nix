{
  config,
  inputs,
  users,
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

    openssh.authorizedKeys.keys = with users.justinhoang.sshKeys; [
      mbp
      lab
    ];
  };

  # Require sudo for wheel group
  security.sudo.wheelNeedsPassword = true;
}
