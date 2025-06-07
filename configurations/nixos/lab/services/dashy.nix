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
          icon = "si-uptimekuma";
          url = mkFqdn "uptime-kuma";
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
          title = "actual";
          description = "finance tracker";
          icon = "hl-actual";
          url = mkFqdn "actual";
        }
        {
          title = "code-server";
          description = "vscode in the web!";
          icon = "hl-code-server";
          url = mkFqdn "code-server";
        }
        {
          title = "mealie";
          description = "recipe and meal manager";
          icon = "hl-mealie";
          url = mkFqdn "mealie";
        }
        {
          title = "paperless";
          description = "document manager";
          icon = "hl-paperless";
          url = mkFqdn "paperless";
        }
        {
          title = "stirling-pdf";
          description = "pdf tools";
          icon = "hl-stirling-pdf";
          url = mkFqdn "stirling-pdf";
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
          url = mkFqdn "audiobookshelf";
        }
        {
          title = "calibre web";
          description = "ebook manager";
          icon = "hl-calibre-web";
          url = mkFqdn "calibre";
        }
        {
          title = "immich";
          description = "photo manager";
          icon = "hl-immich";
          url = mkFqdn "immich";
        }
        {
          title = "jellyfin";
          description = "media server";
          icon = "hl-jellyfin";
          url = mkFqdn "jellyfin";
        }
        {
          title = "jellyseerr";
          description = "media discovery manager";
          icon = "hl-jellyseerr";
          url = mkFqdn "jellyseerr";
        }
        {
          title = "navidrome";
          description = "music manager";
          icon = "hl-navidrome";
          url = mkFqdn "navidrome";
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
          url = "https://${hostName}.${domain}/gitweb";
        }
        {
          title = "wastebin";
          description = "pastebin";
          icon = "si-pastebin";
          url = mkFqdn "wastebin";
        }
      ];
    }
  ];
}
