# custom dashy config per-host
# https://dashy.to/docs/configuring/
{ hostName, domain, ... }:
let
  # service.sua.sh
  mkFqdn = service: "https://${service}.${domain}";
  # service.computer.sua.sh
  mkFullFqdn = service: "https://${service}.${hostName}.${domain}";
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
    logo = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg";
  };

  # define the sections for the home page
  #
  # icon plug
  # - https://dashy.to/docs/icons/
  sections = [
    {
      name = "servers";
      displayData = {
        cols = 2;
        itemSize = "large";
      };
      items = [
        {
          title = "pi";
          description = "raspberry pi";
          icon = "hl-raspberry-pi";
          url = "https://pi.sua.sh";
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
          url = mkFullFqdn "glances";
        }
        {
          title = "grafana";
          description = "hollistic system overview";
          icon = "hl-grafana";
          url = mkFqdn "grafana";
        }
        {
          title = "termix";
          description = "multi-ssh host manager";
          icon = "hl-termix";
          url = mkFqdn "termix";
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
          title = "home assistant";
          description = "self-hosted home automation";
          icon = "hl-home-assistant";
          url = mkFqdn "home-assistant";
        }
        {
          title = "it-tools";
          description = "handy developer tools";
          icon = "hl-it-tools";
          url = mkFqdn "it-tools";
        }
        {
          title = "linkwarden";
          description = "link tracker";
          icon = "hl-linkwarden";
          url = mkFqdn "linkwarden";
        }
        {
          title = "mealie";
          description = "recipe and meal manager";
          icon = "hl-mealie";
          url = mkFqdn "mealie";
        }
        {
          title = "open webui";
          description = "local hosted LLMs";
          icon = "hl-open-webui";
          url = mkFqdn "open-webui";
        }
        {
          title = "paperless";
          description = "document manager";
          icon = "hl-paperless";
          url = mkFqdn "paperless";
        }
        {
          title = "searxng";
          description = "self-hosted meta search engine";
          icon = "hl-searxng";
          url = mkFqdn "searxng";
        }
        {
          title = "stirling-pdf";
          description = "pdf tools";
          icon = "hl-stirling-pdf";
          url = mkFqdn "stirling-pdf";
        }
        {
          title = "vaultwarden";
          description = "secure password manager";
          icon = "hl-vaultwarden";
          url = mkFqdn "vaultwarden";
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
          title = "13ft";
          description = "paywall bypasser";
          icon = "hl-13ft";
          url = mkFqdn "13ft";
        }
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
          title = "miniflux";
          description = "rss feed";
          icon = "hl-miniflux";
          url = mkFqdn "miniflux";
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
          title = "gitea";
          description = "gitea server";
          icon = "hl-gitea";
          url = mkFqdn "gitea";
        }
        {
          title = "hydra";
          description = "nix continuous build system";
          icon = "hl-nixos";
          url = mkFqdn "hydra";
        }
        {
          title = "wastebin";
          description = "pastebin";
          icon = "hl-pastebin";
          url = mkFqdn "wastebin";
        }
      ];
    }
  ];
}
