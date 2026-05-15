# Tailscale client for lab.
# Lab advertises the home LAN (192.168.0.0/24) as a subnet route so other
# Tailscale nodes can reach home services without a separate WireGuard tunnel.
#
# Enrollment: sudo tailscale up --login-server https://hs.sua.dev \
#                                --advertise-routes=192.168.0.0/24
# Then on vps0: headscale nodes register --user sua --key nodekey:xxxx
#               headscale nodes approve-routes --identifier <id> \
#                 --routes "192.168.0.0/24,0.0.0.0/0,::/0"
{
  services.tailscale = {
    enable = true;
    # "server" enables kernel IP forwarding so advertised subnet routes work
    useRoutingFeatures = "server";
  };
}
