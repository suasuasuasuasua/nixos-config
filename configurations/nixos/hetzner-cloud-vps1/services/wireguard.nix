{
  config,
  infra,
  inputs,
  pkgs,
  ...
}:
{
  sops.secrets."wireguard/private_key" = {
    sopsFile = "${inputs.self}/configurations/nixos/hetzner-cloud-vps1/secrets.yaml";
  };

  networking.wireguard = {
    enable = true;
    interfaces.wg1 = {
      ips = [ "${infra.vps1.wg1IP}/24" ];

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          name = "hetzner-cloud-vps0";
          publicKey = infra.vps0.wg1PublicKey;
          endpoint = "${infra.vps0.publicIP}:${toString infra.vps0.wg1Port}";
          # lab (${infra.lab.wgIP}) is routed through VPS0 as hub
          allowedIPs = [
            "${infra.vps0.wg1IP}/32"
            "${infra.lab.wg1IP}/32"
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
