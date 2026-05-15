# Tailscale client for vps0.
# Advertises vps0 as an exit node so devices can route all traffic through
# the Hetzner datacenter IP (useful for geoblocking, untrusted networks, etc.)
#
# Enrollment: sudo tailscale up --login-server https://hs.sua.dev \
#                                --advertise-exit-node
# Then on vps0: headscale nodes register --user sua --key nodekey:xxxx
#               headscale nodes approve-routes --identifier <id> \
#                 --routes "0.0.0.0/0,::/0"
{
  services.tailscale = {
    enable = true;
    # "server" enables kernel IP forwarding required for exit node traffic
    useRoutingFeatures = "server";
  };
}
