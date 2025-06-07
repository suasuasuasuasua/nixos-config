# custom dashy config per-host
# https://dashy.to/docs/configuring/
{ hostName, domain, ... }:
let
  mkFqdn = service: "https://${service}.${hostName}.${domain}";
in
{
  pageInfo = {
    description = "sua's homelab";
    navLinks = [
      {
        path = "/";
        title = "home";
      }
    ];
    title = hostName; # tagged with hostname
    # TODO: broken safari lol
    # logo = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg";
  };

  # define the sections for the home page
  #
  # icon plug
  # - https://dashy.to/docs/icons/
  sections = [
    {
      name = "networking";
      displayData = {
        cols = 2;
        itemSize = "large";
      };
      items = [
        {
          title = "adguardhome";
          description = "dns blocker";
          icon = "hl-adguard-home";
          url = mkFqdn "adguardhome";
        }
      ];
    }
    {
      name = "monitoring";
      displayData = {
        cols = 2;
        itemSize = "large";
      };
      items = [
        {
          title = "glances";
          description = "system overview";
          icon = "hl-glances";
          url = mkFqdn "glances";
        }
        {
          title = "uptime-kuma";
          description = "fancy service monitoring";
          icon = "hl-uptime-kuma";
          url = mkFqdn "uptime-kuma";
        }
      ];
    }
  ];
}
