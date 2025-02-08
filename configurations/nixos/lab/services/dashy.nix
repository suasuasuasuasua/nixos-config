# custom dashy config per-host
# https://dashy.to/docs/configuring/

{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
in
{
  # define the general sections
  services.dashy.settings = {
    appConfig = {
      enableFontAwesome = true;
      fontAwesomeKey = "e9076c7025";
      theme = "dashy-docs";
      layout = "vertical";
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
          title = "adguard";
          description = "adguard home dns blocker";
          icon = "hl-adguardhome";
          target = "newtab";
          url = "http://adguard.${hostName}.home";
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
    {
      name = "productivity";
      displayData = {
        cols = 2;
        itemSize = "large";
      };
      items = [
        {
          title = "mealie";
          description = "recipe and meal tracker";
          icon = "hl-mealie";
          target = "newtab";
          url = "http://mealie.${hostName}.home";
        }
        {
          title = "actual";
          description = "finance tracker";
          icon = "hl-actual";
          target = "newtab";
          url = "http://actual.${hostName}.home";
        }
        {
          title = "gitweb";
          description = "gitweb server";
          icon = "si-git";
          target = "newtab";
          url = "http://${hostName}.home/gitweb";
        }
      ];
    }
    {
      name = "media";
      displayData = {
        cols = 2;
        itemSize = "large";
      };
      items = [
        {
          title = "jellyfin";
          description = "media server";
          icon = "hl-jellyfin";
          target = "newtab";
          url = "http://jellyfin.${hostName}.home";
        }
        {
          title = "navidrome";
          description = "music manager";
          icon = "hl-navidrome";
          target = "newtab";
          url = "http://navidrome.${hostName}.home";
        }
      ];
    }
  ];
}
