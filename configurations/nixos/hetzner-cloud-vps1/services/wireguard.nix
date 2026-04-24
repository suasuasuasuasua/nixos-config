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
      ips = [ "${infra.vps1.wgIp}/24" ];

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          name = "hetzner-cloud-vps0";
          publicKey = infra.vps0.wgPublicKey;
          endpoint = "${infra.vps0.publicIp}:${toString infra.vps0.wgPort}";
          # lab (${infra.lab.wgIp}) is routed through VPS0 as hub
          allowedIPs = [
            "${infra.vps0.wgIp}/32"
            "${infra.lab.wgIp}/32"
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
