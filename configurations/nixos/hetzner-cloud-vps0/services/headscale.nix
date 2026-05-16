# Headscale — self-hosted Tailscale coordination server.
# Replaces the manual wg0 WireGuard mesh (key management, peer lists, etc.)
# with a proper control plane. Tailscale clients on all devices point here.
#
# Listens on localhost:8080; nginx proxies it at https://hs.sua.dev.
#
# First-time setup after deploying:
#   1. Create a user:       headscale users create sua
#   2. Enroll a node:       sudo tailscale up --login-server https://hs.sua.dev
#                           headscale nodes register --user sua --key nodekey:xxxx
#   3. Enable pi's subnet:  headscale nodes approve-routes --identifier <id> \
#                             --routes "192.168.0.0/24"
#
# Personal devices (iOS, macOS): Tailscale app → Settings → Use custom login server → https://hs.sua.dev
{
  config,
  pkgs,
  infra,
  ...
}:
{
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = infra.ports.headscale;
    settings = {
      server_url = "https://hs.${config.networking.domain}";
      noise.private_key_path = "/var/lib/headscale/noise_private.key";
      ip_prefixes = [ "100.64.0.0/10" ];
      dns = {
        magic_dns = true;
        # Nodes get names like lab.ts.sua.dev
        base_domain = "ts.${config.networking.domain}";
        # Split DNS routes sua.dev queries to AdGuard; public DNS handles everything else.
        nameservers = {
          split."${config.networking.domain}" = [ infra.pi.tsIP ];
          global = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
      };
      # Embedded DERP relay for clients behind CGNAT that can't do direct P2P.
      # STUN (UDP 3478) is opened in the firewall; DERP runs over port 443 via nginx.
      derp = {
        server = {
          enabled = true;
          region_id = 999;
          region_code = "headscale";
          region_name = "Headscale Embedded DERP";
          stun_listen_addr = "0.0.0.0:${toString infra.ports.stun}";
        };
        urls = [ "https://controlplane.tailscale.com/derpmap/default" ];
        auto_update_enabled = true;
        update_frequency = "24h";
      };
      log.level = "info";
    };
  };

  # headscale CLI for managing users, nodes, pre-auth keys, API keys
  environment.systemPackages = [ pkgs.headscale ];
}
