{
  inputs,
  pkgs,
  config,
  ...
}:
let
  labIp = "10.101.0.2";
  vps0Ip = "10.101.0.1";
  vps0Endpoint = "5.78.184.15:51820";
  vps1Ip = "10.101.0.3";

  hetzner-cloud-vps0-key = "k2a0D0OUEsZQV6geIKOscTNVbiUVZquqh49zT6A1MRo=";
in
{
  sops.secrets."wireguard/private_key" = {
    sopsFile = "${inputs.self}/configurations/nixos/hetzner-cloud-vps1/secrets.yaml";
  };

  networking.wireguard = {
    enable = true;
    interfaces.wg1 = {
      ips = [ "${vps1Ip}/24" ];

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          name = "hetzner-cloud-vps0";
          publicKey = hetzner-cloud-vps0-key;
          endpoint = vps0Endpoint;
          # lab (10.101.0.2) is routed through VPS0 as hub
          allowedIPs = [
            "${vps0Ip}/32"
            "${labIp}/32"
          ];
          persistentKeepalive = 25;
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
