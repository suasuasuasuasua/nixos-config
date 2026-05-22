# FlareSolverr bypasses Cloudflare bot protection for Prowlarr indexers.
# After deploying, add it in Prowlarr: Settings > Indexers > Add FlareSolverr
#   Tag: flaresolverr, Host: http://localhost:8191
# Then assign the tag to Cloudflare-protected indexers (e.g. 1337x).
{ infra, ... }:
{
  services.flaresolverr = {
    enable = true;
    port = infra.ports.flaresolverr;
  };
}
