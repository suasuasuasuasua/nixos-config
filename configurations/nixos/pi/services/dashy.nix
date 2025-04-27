# custom dashy config per-host
# https://dashy.to/docs/configuring/
{ hostName, ... }:
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
          icon = "hl-adguardhome";
          target = "newtab";
          url = "http://adguardhome.${hostName}.home";
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
          target = "newtab";
          url = "http://glances.${hostName}.home";
        }
      ];
    }
  ];
}
