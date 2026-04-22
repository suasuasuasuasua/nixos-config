# WireGuard VPN server on VPS
# This is the endpoint that lab connects to
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  labPublicKey = "JVBP0NWpR70JT0bUoFsunFkGT9YZSY8O/UeMdUxAXlU=";
in
{
  sops.secrets."wireguard/private_key" = {
    sopsFile = "${inputs.self}/configurations/nixos/vps/secrets.yaml";
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      ips = [ "10.101.0.1/24" ];
      listenPort = 51820;

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          name = "lab";
          publicKey = labPublicKey;
          allowedIPs = [ "10.101.0.2/32" ];
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
