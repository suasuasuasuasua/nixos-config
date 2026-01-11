{
  pkgs,
  lib,
  settings,
  ...
}:
let
  # NOTE: you can add keyword (str) and tags (array) as well
  #  tags are interesting...but i don't think i will ever be using it
  mkBookmark = name: url: {
    inherit
      name
      url
      ;
  };
in
{
  personal = {
    inherit settings;

    id = 0;
    bookmarks = {
      force = true;
      settings = [
        {
          name = "bookmarks toolbar";
          toolbar = true;
          bookmarks = [
            (mkBookmark "youtube" "https://youtube.com")
            {
              name = "servers";
              bookmarks = [
                (mkBookmark "lab" "https://lab.sua.dev")
                (mkBookmark "pi" "https://pi.sua.dev")
              ];
            }
            {
              name = "self-hosted services";
              bookmarks = [
                (mkBookmark "13ft" "https://13ft.sua.dev")
                (mkBookmark "actual" "https://actual.sua.dev")
                (mkBookmark "adguardhome" "https://adguardhome.sua.dev")
                (mkBookmark "audiobookshelf" "https://audiobookshelf.sua.dev")
                (mkBookmark "calibre" "https://calibre.sua.dev")
                (mkBookmark "gitea" "https://gitea.sua.dev")
                (mkBookmark "glances (lab)" "https://glances.lab.sua.dev")
                (mkBookmark "glances (pi)" "https://glances.pi.sua.dev")
                (mkBookmark "grafana" "https://grafana.sua.dev")
                (mkBookmark "home-assistant" "https://home-assistant.sua.dev")
                (mkBookmark "hydra" "https://hydra.sua.dev")
                (mkBookmark "immich" "https://immich.sua.dev")
                (mkBookmark "it-tools" "https://it-tools.sua.dev")
                (mkBookmark "jellyfin" "https://jellyfin.sua.dev")
                (mkBookmark "linkwarden" "https://linkwarden.sua.dev")
                (mkBookmark "mealie" "https://mealie.sua.dev")
                (mkBookmark "miniflux" "https://miniflux.sua.dev")
                (mkBookmark "navidrome" "https://navidrome.sua.dev")
                (mkBookmark "open-webui" "https://open-webui.sua.dev")
                (mkBookmark "paperless" "https://paperless.sua.dev")
                (mkBookmark "searxng" "https://searxng.sua.dev")
                (mkBookmark "stirling-pdf" "https://stirling-pdf.sua.dev")
                (mkBookmark "termix" "https://termix.sua.dev")
                (mkBookmark "uptime-kuma" "https://uptime-kuma.sua.dev")
                (mkBookmark "vaultwarden" "https://vaultwarden.sua.dev")
                (mkBookmark "wastebin" "https://wastebin.sua.dev")
              ];
            }
            {
              name = "email";
              bookmarks = [
                (mkBookmark "gmail" "https://mail.google.com")
                (mkBookmark "outlook" "https://outlook.live.com/")
                (mkBookmark "proton" "https://mail.proton.me")
              ];
            }
            {
              name = "finances";
              bookmarks = [
                (mkBookmark "chase" "https://secure.chase.com")
                (mkBookmark "empower" "https://lockheedmartinsavings.empower-retirement.com")
                (mkBookmark "fidelity" "https://digital.fidelity.com")
                (mkBookmark "usbank" "https://onlinebanking.usbank.com")
              ];
            }
            {
              name = "benefits";
              bookmarks = [
                (mkBookmark "dental" "https://cigna.dental.com/dashboard")
                (mkBookmark "health" "https://my.cigna.com")
                (mkBookmark "vision" "https://www.vsp.com/")
              ];
            }
            {
              name = "bills";
              bookmarks = [
                (mkBookmark "car insurance" "https://myaccount.amfam.com/2812/overview")
                (mkBookmark "golden ridge portal" "https://outlookgoldenridge.securecafe.com/residentservices/outlook-golden/home.aspx")
                (mkBookmark "internet" "https://www.quantumfiber.com")
                (mkBookmark "parking" "https://parkm.app")
              ];
            }
            (mkBookmark "hacker news" "https://news.ycombinator.com")
            (mkBookmark "reddit" "https://reddit.com")
            {
              name = "nix";
              bookmarks = [
                (mkBookmark "home-manager extranix options" "https://home-manager-options.extranix.com/")
                (mkBookmark "home-manager options" "https://nix-community.github.io/home-manager/options.xhtml")
                (mkBookmark "nix wiki" "https://wiki.nixos.org")
                (mkBookmark "nix2json webui" "https://json-to-nix.pages.dev")
                (mkBookmark "nixpkgs options" "https://search.nixos.org/options?")
                (mkBookmark "nixpkgs" "https://search.nixos.org/packages")
                (mkBookmark "nixvim search" "https://nix-community.github.io/nixvim/search/")
                (mkBookmark "nixvim" "https://nix-community.github.io/nixvim/")
                (mkBookmark "noogle" "https://noogle.dev/")
              ];
            }
            {
              name = "darwin";
              bookmarks = [
                (mkBookmark "brew" "https://brew.sh/")
              ];
            }
          ];
        }
      ];
    };
    # https://nur.nix-community.org/repos/rycee/
    extensions = {
      force = true;
      # TODO: add configs for extensions
      #       for example, dark reader should follow system theme
      packages =
        with pkgs.firefox-addons;
        [
          betterttv # twitch [dot] tv integration
          bitwarden # bit/vault warden password integration
          darkreader # automatic dark mode
          linkwarden # link saver
          ublock-origin # block ads
          unpaywall # read research papers for free
          vimium # vim-like movements
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          plasma-integration
        ];
    };
    search = {
      force = true;
      default = "ddg"; # duckduckgo
      privateDefault = "ddg"; # duckduckgo
      engines = {
        bing.metaData.hidden = true;
        google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        nix-packages = {
          name = "Nix Packages";
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [
            "@nix-packages"
            "@np"
          ];
        };
        nix-options = {
          name = "Nix Options";
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [
            "@nix-options"
            "@no"
          ];
        };
        nixos-wiki = {
          name = "NixOS Wiki";
          urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
          # NOTE: fetch url is a bit laggy sometimes
          # iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [
            "@nixos-wiki"
            "@nw"
          ];
        };
        searxng = {
          name = "SearXNG";
          urls = [ { template = "https://searxng.sua.dev/search?q={searchTerms}"; } ];
          iconMapObj."16" = "https://searxng.sua.dev/favicon.ico";
          definedAliases = [
            "@searxng"
            "@sx"
          ];
        };
        wikipedia.metaData.alias = "@w"; # builtin engines only support specifying one additional alias
      };
      order = [
        "@ddg" # duckduckgo
        "@sx" # searxng
        "@g" # google
        "@w" # wikipedia
      ];
    };
  };
  productivity = {
    inherit settings;

    id = 1;
    bookmarks = {
      force = true;
      settings = [
        (mkBookmark "kernel.org" "https://www.kernel.org")
        (mkBookmark "wikipedia" "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go")
        {
          name = "Nix sites";
          toolbar = true;
          bookmarks = [
            (mkBookmark "homepage" "https://nixos.org/")
            (mkBookmark "wiki" "https://wiki.nixos.org/")
          ];
        }
      ];
    };

    # https://nur.nix-community.org/repos/rycee/
    extensions = {
      force = true;
    };
  };
}
