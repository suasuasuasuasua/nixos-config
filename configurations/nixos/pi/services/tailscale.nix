# Tailscale client for pi.
# Pi advertises the home LAN (192.168.0.0/24) as a subnet route and acts as
# the network-wide DNS (AdGuard) for all Tailscale nodes. Using pi rather than
# lab means DNS and subnet routing share a single dependency.
#
# Enrollment: sudo tailscale up --login-server https://hs.sua.dev \
#                                --advertise-routes=192.168.0.0/24
# Then on vps0: headscale nodes register --user sua --key nodekey:xxxx
#               headscale nodes approve-routes --identifier <pi-id> \
#                 --routes "192.168.0.0/24"
{
  services.tailscale = {
    enable = true;
    # "server" enables kernel IP forwarding so advertised subnet routes work
    useRoutingFeatures = "server";
  };
}
