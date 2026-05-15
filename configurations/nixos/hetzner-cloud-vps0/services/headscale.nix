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
#   3. Enable lab's subnet: headscale nodes approve-routes --identifier <id> \
#                             --routes "192.168.0.0/24,0.0.0.0/0,::/0"
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
        # Required when override_local_dns = true (the default).
        # Switch to infra.pi.lanIP once the lab subnet route is active
        # and you want AdGuardHome as the network-wide DNS for Tailscale nodes.
        nameservers.global = [
          infra.pi.lanIP
          # fallbacks
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
      log.level = "info";
    };
  };

  # headscale CLI for managing users, nodes, pre-auth keys, API keys
  environment.systemPackages = [ pkgs.headscale ];
}
