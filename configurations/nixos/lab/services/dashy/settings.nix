# custom dashy config per-host
# https://dashy.to/docs/configuring/
{ domain, hostName, ... }:
let
  # service.sua.dev
  mkFqdn = service: "https://${service}.${domain}";
  # service.computer.sua.dev
  mkFullFqdn = service: "https://${service}.${hostName}.${domain}";
  # service.host.sua.dev
  mkHostFqdn = host: service: "https://${service}.${host}.${domain}";
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
  };

  # define the sections for the home page
  #
  # icon plug
  # - https://dashy.to/docs/icons/
  # - selfh.st icons use sh- prefix (https://dashy.to/docs/icons#selfhst-icons)
  sections = [
    {
      name = "monitoring";
      displayData = {
        cols = 2;
        itemSize = "large";
      };
      items = [
        {
          title = "glances (lab)";
          description = "system overview";
          icon = "sh-glances";
          url = mkFullFqdn "glances";
          tags = [ "lab" ];
        }
        {
          title = "glances (pi)";
          description = "system overview";
          icon = "sh-glances";
          url = mkHostFqdn "pi" "glances";
          tags = [ "pi" ];
        }
        {
          title = "grafana";
          description = "hollistic system overview";
          icon = "sh-grafana";
          url = mkFqdn "grafana";
        }
        {
          title = "termix";
          description = "multi-ssh host manager";
          icon = "sh-termix";
          url = mkFqdn "termix";
        }
        {
          title = "adguardhome";
          description = "dns blocker";
          icon = "sh-adguard-home";
          url = mkFqdn "adguardhome";
          tags = [ "pi" ];
        }
        {
          title = "uptime-kuma";
          description = "fancy service monitoring";
          icon = "sh-uptime-kuma";
          url = mkFqdn "uptime-kuma";
          tags = [ "pi" ];
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
          icon = "sh-actual-budget";
          url = mkFqdn "actual";
        }
        {
          title = "home assistant";
          description = "self-hosted home automation";
          icon = "sh-home-assistant";
          url = mkFqdn "home-assistant";
        }
        {
          title = "it-tools";
          description = "handy developer tools";
          icon = "sh-it-tools";
          url = mkFqdn "it-tools";
        }
        {
          title = "linkwarden";
          description = "link tracker";
          icon = "sh-linkwarden";
          url = mkFqdn "linkwarden";
        }
        {
          title = "mealie";
          description = "recipe and meal manager";
          icon = "sh-mealie";
          url = mkFqdn "mealie";
        }
        {
          title = "paperless";
          description = "document manager";
          icon = "sh-paperless-ngx";
          url = mkFqdn "paperless";
        }
        {
          title = "searxng";
          description = "self-hosted meta search engine";
          icon = "sh-searxng";
          url = mkFqdn "searxng";
        }
        {
          title = "stirling-pdf";
          description = "pdf tools";
          icon = "sh-stirling-pdf";
          url = mkFqdn "stirling-pdf";
        }
        {
          title = "vaultwarden";
          description = "secure password manager";
          icon = "sh-vaultwarden";
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
          icon = "fas fa-unlock";
          url = mkFqdn "13ft";
        }
        {
          title = "audiobookshelf";
          description = "audiobook manager";
          icon = "sh-audiobookshelf";
          url = mkFqdn "audiobookshelf";
        }
        {
          title = "calibre web";
          description = "ebook manager";
          icon = "sh-calibre-web";
          url = mkFqdn "calibre";
        }
        {
          title = "immich";
          description = "photo manager";
          icon = "sh-immich";
          url = mkFqdn "immich";
        }
        {
          title = "jellyfin";
          description = "media server";
          icon = "sh-jellyfin";
          url = mkFqdn "jellyfin";
        }
        {
          title = "navidrome";
          description = "music manager";
          icon = "sh-navidrome";
          url = mkFqdn "navidrome";
        }
      ];
    }
    {
      name = "arr";
      displayData = {
        cols = 2;
        itemSize = "large";
      };
      items = [
        {
          title = "prowlarr";
          description = "indexer manager";
          icon = "sh-prowlarr";
          url = mkFqdn "prowlarr";
        }
        {
          title = "sonarr";
          description = "tv show collection manager";
          icon = "sh-sonarr";
          url = mkFqdn "sonarr";
        }
        {
          title = "radarr";
          description = "movie collection manager";
          icon = "sh-radarr";
          url = mkFqdn "radarr";
        }
        {
          title = "lidarr";
          description = "music collection manager";
          icon = "sh-lidarr";
          url = mkFqdn "lidarr";
        }
        {
          title = "bazarr";
          description = "subtitle manager";
          icon = "sh-bazarr";
          url = mkFqdn "bazarr";
        }
        {
          title = "qbittorrent";
          description = "torrent download client";
          icon = "sh-qbittorrent";
          url = mkFqdn "qbittorrent";
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
          icon = "sh-gitea";
          url = mkFqdn "gitea";
        }
        {
          title = "wastebin";
          description = "pastebin";
          icon = "sh-wastebin";
          url = mkFqdn "wastebin";
        }
      ];
    }
  ];
}
