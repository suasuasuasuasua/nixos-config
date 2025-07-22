# https://wiki.nixos.org/wiki/Nginx
{
  imports = [ ./virtualHosts.nix ];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
  };

  users.users.nginx.extraGroups = [ "samba" ];
}
