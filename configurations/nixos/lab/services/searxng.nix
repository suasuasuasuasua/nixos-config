# https://wiki.nixos.org/wiki/SearXNG
# free and open-source metasearch engine that aggregates results
{
  inputs,
  config,
  lib,
  ...
}:
let
  serviceName = "searxng";
  inherit (config.networking) hostName domain;

  environmentFile = config.sops.secrets."searxng/environmentFile";
  # port = 8080
  port = 8084;
in
{
  sops.secrets = {
    "searxng/environmentFile" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  services.searx = {
    enable = true;
    redisCreateLocally = true;
    environmentFile = environmentFile.path;

    # Rate limiting
    limiterSettings = {
      real_ip = {
        x_for = 1;
        ipv4_prefix = 32;
        ipv6_prefix = 56;
      };

      botdetection = {
        ip_limit = {
          filter_link_local = true;
          link_token = true;
        };
      };
    };
    settings = {
      general = {
        debug = false;
        instance_name = "sua's searxng";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = false;
      };

      # User interface
      ui = {
        static_use_hash = true;
        default_locale = "en";
        query_in_title = true;
        infinite_scroll = false;
        center_alignment = true;
        default_theme = "simple";
        theme_args.simple_style = "auto";
        search_on_category_select = false;
        hotkeys = "vim";
      };

      # Search engine settings
      search = {
        safe_search = 2;
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
      };

      server = {
        inherit port;

        base_url = "https://${serviceName}.${domain}";
        bind_address = "::1";
        limiter = true;
        public_instance = false;
        image_proxy = true;
        method = "GET";
      };

      # Search engines (see the settings menu)
      # https://docs.searxng.org/user/configured_engines.html
      engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
        ## general
        # translate
        "dictzone".disabled = false;
        "libretranslate".disabled = true;
        "lingva".disabled = false;
        "mozhi".disabled = true;
        "mymemory translated".disabled = false;
        # web
        "bing".disabled = true;
        "brave".disabled = false;
        "duckduckgo".disabled = false;
        "google".disabled = false;
        "mojeek".disabled = true;
        "mullvadleta".disabled = true;
        "mullvadleta brave".disabled = true;
        "presearch".disabled = true;
        "presearch videos".disabled = true;
        "qwant".disabled = true;
        "startpage".disabled = false;
        "wiby".disabled = true;
        "yahoo".disabled = true;
        "seznam (CZ)".disabled = true;
        "goo (JA)".disabled = true;
        "naver (KO)".disabled = true;
        # wikimedia
        "wikibooks".disabled = true;
        "wikiquote".disabled = true;
        "wikisource".disabled = true;
        "wikispecies".disabled = true;
        "wikiversity".disabled = true;
        "wikivoyage".disabled = true;
        # without further subgrouping
        "alexandria".disabled = true;
        "ask".disabled = true;
        "cloudflareai".disabled = true;
        "crowdview".disabled = true;
        "currency".disabled = false;
        "ddg definitions".disabled = true;
        "encyclosearch".disabled = true;
        "mwmbl".disabled = true;
        "right dao".disabled = true;
        "searchmysite".disabled = true;
        "stract".disabled = true;
        "tineye".disabled = true;
        "wikidata".disabled = false;
        "wikipedia".disabled = false;
        "wolframalpha".disabled = true;
        "yacy".disabled = true;
        "yep".disabled = true;
        "bpb (DE)".disabled = true;
        "tagesschau (DE)".disabled = true;
        "wikimini (FR)".disabled = true;
        "360search (ZH)".disabled = true;
        "baidu (ZH)".disabled = true;
        "quark (ZH)".disabled = true;
        "sogou (ZH)".disabled = true;
        ## images
        # icons
        "material icons".disabled = true;
        "svgrepo".disabled = true;
        "uxwing".disabled = true;
        # web
        "bing images".disabled = false;
        "brave.images".disabled = false;
        "duckduckgo images".disabled = true;
        "google images".disabled = false;
        "mojeek images".disabled = true;
        "presearch images".disabled = true;
        "qwant images".disabled = false;
        "startpage images".disabled = false;
        # without further subgrouping
        "1x".disabled = true;
        "adobe stock".disabled = true;
        "artic".disabled = false;
        "deviantart".disabled = false;
        "findthatmeme".disabled = true;
        "flickr".disabled = false;
        "frinkiac".disabled = true;
        "imgur".disabled = true;
        "ipernity".disabled = true;
        "library of congress".disabled = true;
        "openverse".disabled = false;
        "pinterest".disabled = false;
        "pixabay images".disabled = true;
        "public domain image archive".disabled = false;
        "sogou images".disabled = true;
        "unsplash".disabled = false;
        "wallhaven".disabled = true;
        "wikicommons.images".disabled = false;
        "yacy images".disabled = true;
        "yep images".disabled = true;
        "seekr images (EN)".disabled = true;
        "naver images (KO)".disabled = true;
        "baidu images (ZH)".disabled = true;
        "quark images (ZH)".disabled = true;
        ## videos
        # web
        "bing videos".disabled = false;
        "brave.videos".disabled = false;
        "duckduckgo videos".disabled = true;
        "google videos".disabled = false;
        "qwant videos".disabled = false;
        # without further subgrouping
        "360search videos".disabled = true;
        "adobe stock video".disabled = true;
        "bilibili".disabled = true;
        "bitchute".disabled = true;
        "dailymotion".disabled = false;
        "google play movies".disabled = true;
        "livespace".disabled = true;
        "media.ccc.de".disabled = true;
        "odysee".disabled = true;
        "peertube".disabled = true;
        "piped".disabled = false;
        "pixabay videos".disabled = true;
        "rumble".disabled = true;
        "sepiasearch".disabled = false;
        "vimeo".disabled = false;
        "wikicommons.video".disabled = false;
        "youtube".disabled = false;
        "mediathekviewweb (DE)".disabled = true;
        "seekr videos (EN)".disabled = true;
        "ina (FR)".disabled = true;
        "niconico (JA)".disabled = true;
        "naver videos (KO)".disabled = true;
        "acfun (ZH)".disabled = true;
        "iqiyi (ZH)".disabled = true;
        "sogou videos (ZH)".disabled = true;
        ## news
        # web
        "duckduckgo news".disabled = true;
        "mojeek news".disabled = true;
        "presearch news".disabled = true;
        "startpage news".disabled = false;
        # wikimedia
        "wikinews".disabled = false;
        # without further subgrouping
        "bing news".disabled = false;
        "brave news".disabled = false;
        "google news".disabled = false;
        "qwant news".disabled = false;
        "reuters".disabled = false;
        "yahoo news".disabled = false;
        "yep news".disabled = true;
        "seekr news (EN)".disabled = true;
        "ansa (IT)".disabled = true;
        "il post (IT)".disabled = true;
        "naver news (KO)".disabled = true;
        "sogou wechat (ZH)".disabled = true;
        ## map
        # general
        "apple maps".disabled = true;
        "openstreetmap".disabled = false;
        "photon".disabled = false;
        ## music
        # lyrics
        "genius".disabled = false;
        # radio
        "radio browser".disabled = false;
        # without further subgrouping
        "adobe stock audio".disabled = true;
        "bandcamp".disabled = false;
        "deezer".disabled = true;
        "mixcloud".disabled = false;
        "piped.music".disabled = false;
        "soundcloud".disabled = false;
        "wikicommon.audio".disabled = false;
        ## it
        # package
        "alpine linux packages".disabled = true;
        "crates.io".disabled = true;
        "docker hub".disabled = false;
        "hex".disabled = true;
        "hoogle".disabled = false;
        "lib.rs".disabled = true;
        "metacpan".disabled = true;
        "npm".disabled = true;
        "packagist".disabled = true;
        "pkg.go.dev".disabled = true;
        "pypi".disabled = true;
        "rubygems".disabled = true;
        "voidlinux".disabled = true;
        # q&a
        "askubuntu".disabled = false;
        "caddy.community".disabled = true;
        "discuss.python".disabled = true;
        "pi-hole.community".disabled = true;
        "stackoverflow".disabled = false;
        "superuser".disabled = false;
        # repos
        "bitbucket".disabled = true;
        "codeberg".disabled = true;
        "gitea.com".disabled = true;
        "github".disabled = false;
        "gitlab".disabled = true;
        "huggingface".disabled = true;
        "huggingface datasets".disabled = true;
        "huggingface spaces".disabled = true;
        "ollama".disabled = true;
        "sourcehut".disabled = true;
        # software wikis
        "arch linux wiki".disabled = false;
        "free software directory".disabled = true;
        "gentoo".disabled = true;
        "nixos wiki".disabled = false;
        # without further subgrouping
        "anaconda".disabled = true;
        "cppreference".disabled = true;
        "habrahabr".disabled = true;
        "hackernews".disabled = true;
        "lobste.rs".disabled = true;
        "mankier".disabled = false;
        "mdn".disabled = false;
        "microsoft learn".disabled = true;
        "searchcode code".disabled = true;
        "baidu kaifa (ZH)".disabled = true;
        ## science
        # scientific publications
        "arxiv".disabled = false;
        "crossref".disabled = true;
        "google scholar".disabled = false;
        "pubmed".disabled = false;
        "semantic scholar".disabled = true;
        # without further subgrouping
        "openairedatasets".disabled = false;
        "openairepublications".disabled = false;
        "pdbe".disabled = false;
        ## files
        # apps
        "apk mirror".disabled = true;
        "apple app store".disabled = true;
        "fdroid".disabled = true;
        "google play apps".disabled = true;
        # without further subgrouping
        "1337x".disabled = true;
        "annas archive".disabled = true;
        "bt4g".disabled = false;
        "btdigg".disabled = true;
        "kickass".disabled = false;
        "library genesis".disabled = true;
        "nyaa".disabled = true;
        "openrepos".disabled = true;
        "piratebay".disabled = false;
        "solidtorrents".disabled = false;
        "tokyotoshokan".disabled = true;
        "wikicommons.files".disabled = false;
        "z-library".disabled = true;
        ## social media
        # general
        "9gag".disabled = true;
        "lemmy comments".disabled = false;
        "lemmy communities".disabled = false;
        "lemmy posts".disabled = false;
        "lemmy users".disabled = false;
        "mastodon hashtags".disabled = false;
        "mastodon users".disabled = false;
        "reddit".disabled = false;
        "tootfinder".disabled = false;
        ## other
        # dictionaries
        "etymonline".disabled = false;
        "wikitionary".disabled = false;
        "wordnik".disabled = false;
        "duden (DE)".disabled = true;
        "woxikon.de synonyme (DE)".disabled = true;
        "jisho (JA)".disabled = true;
        # movies
        "imdb".disabled = true;
        "rottentomatoes".disabled = true;
        "tmdb".disabled = true;
        "moviepilot (DE)".disabled = true;
        "senscritique (FR)".disabled = true;
        # shopping
        "geizhals (DE)".disabled = true;
        # software wikis
        "minecraft wiki".disabled = true;
        # weather
        "duckduckgo weather".disabled = true;
        "openmeteo".disabled = true;
        "wttr.in".disabled = false;
        # without further subgrouping
        "emojipedia".disabled = true;
        "erowid".disabled = true;
        "fyyd".disabled = true;
        "goodreads".disabled = true;
        "openlibrary".disabled = true;
        "podcastindex".disabled = false;
        "steam".disabled = true;
        "yummly".disabled = true;
        "chefkoch (DE)".disabled = false;
        "destatis (DE)".disabled = true;
      };

      # Outgoing requests
      outgoing = {
        request_timeout = 5.0;
        max_request_timeout = 15.0;
        pool_connections = 100;
        pool_maxsize = 15;
        enable_http2 = true;
      };

      # Enabled plugins
      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };
  };

  # Systemd configuration
  systemd.services.nginx.serviceConfig.ProtectHome = false;

  # User management
  users.groups.searx.members = [ "nginx" ];

  # Nginx configuration
  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://[::1]:${toString port}";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
