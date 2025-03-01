# custom dashy config per-host
# https://dashy.to/docs/configuring/
{ lib, config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;

  cfg = config.nixos.services.dashy;
in
{
  config = lib.mkIf cfg.enable {
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
      {
        name = "productivity";
        displayData = {
          cols = 2;
          itemSize = "large";
        };
        items = [
          {
            title = "code-server";
            description = "vscode in the web!";
            icon = "hl-code-server";
            target = "newtab";
            url = "http://code-server.${hostName}.home";
          }
          {
            title = "mealie";
            description = "recipe and meal manager";
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
            title = "paperless";
            description = "document manager";
            icon = "hl-paperless";
            target = "newtab";
            url = "http://paperless.${hostName}.home";
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
            title = "audiobookshelf";
            description = "audiobook manager";
            icon = "hl-audiobookshelf";
            target = "newtab";
            url = "http://audiobookshelf.${hostName}.home";
          }
          {
            title = "calibre web";
            description = "ebook manager";
            icon = "hl-calibre-web";
            target = "newtab";
            url = "http://calibre.${hostName}.home";
          }
          {
            title = "immich";
            description = "photo manager";
            icon = "hl-immich";
            target = "newtab";
            url = "http://immich.${hostName}.home";
          }
          {
            title = "jellyfin";
            description = "media server";
            icon = "hl-jellyfin";
            target = "newtab";
            url = "http://jellyfin.${hostName}.home";
          }
          {
            title = "jellyseerr";
            description = "media discovery manager";
            icon = "hl-jellyseerr";
            target = "newtab";
            url = "http://jellyseerr.${hostName}.home";
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
      {
        name = "sharing";
        displayData = {
          cols = 2;
          itemSize = "large";
        };
        items = [
          {
            title = "gitweb";
            description = "gitweb server";
            icon = "si-git";
            target = "newtab";
            url = "http://${hostName}.home/gitweb";
          }
          {
            title = "wastebin";
            description = "pastebin";
            icon = "si-pastebin";
            target = "newtab";
            url = "http://wastebin.${hostName}.home";
          }
        ];
      }
    ];
  };
}
