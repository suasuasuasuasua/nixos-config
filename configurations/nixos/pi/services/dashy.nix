# custom dashy config per-host
# https://dashy.to/docs/configuring/
{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
in
{
  # define the general sections
  services.dashy.settings = {
    appConfig = {
      enableFontAwesome = true;
      fontAwesomeKey = "e9076c7025";
      layout = "auto";

      theme = "basic";
    };
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
  };

  # define the sections for the home page
  #
  # icon plug
  # - https://dashy.to/docs/icons/
  services.dashy.settings.sections = [
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
