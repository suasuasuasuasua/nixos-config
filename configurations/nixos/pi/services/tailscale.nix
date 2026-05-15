# Tailscale client for pi.
# Enrollment: sudo tailscale up --login-server https://hs.sua.dev
# Then on vps0: headscale nodes register --user sua --key nodekey:xxxx
{
  services.tailscale.enable = true;
}
