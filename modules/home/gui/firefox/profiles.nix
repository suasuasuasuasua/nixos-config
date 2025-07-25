{ pkgs, settings, ... }:
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
                (mkBookmark "lab" "https://lab.sua.sh")
                (mkBookmark "pi" "https://pi.sua.sh")
              ];
            }
            {
              name = "self-hosted services";
              bookmarks = [
                (mkBookmark "actual" "https://actual.sua.sh")
                (mkBookmark "adguardhome" "https://adguardhome.sua.sh")
                (mkBookmark "audiobookshelf" "https://audiobookshelf.sua.sh")
                (mkBookmark "calibre" "https://calibre.sua.sh")
                (mkBookmark "gitea" "https://gitea.sua.sh")
                (mkBookmark "glances (lab)" "https://glances.lab.sua.sh")
                (mkBookmark "glances (pi)" "https://glances.pi.sua.sh")
                (mkBookmark "home-assistant" "https://home-assistant.sua.sh")
                (mkBookmark "hydra" "https://hydra.sua.sh")
                (mkBookmark "immich" "https://immich.sua.sh")
                (mkBookmark "jellyfin" "https://jellyfin.sua.sh")
                (mkBookmark "jellyseerr" "https://jellyseerr.sua.sh")
                (mkBookmark "mealie" "https://mealie.sua.sh")
                (mkBookmark "miniflux" "https://miniflux.sua.sh")
                (mkBookmark "navidrome" "https://navidrome.sua.sh")
                (mkBookmark "open webui" "https://open-webui.sua.sh")
                (mkBookmark "paperless" "https://paperless.sua.sh")
                (mkBookmark "searxng" "https://searxng.sua.sh")
                (mkBookmark "stirling-pdf" "https://stirling-pdf.sua.sh")
                (mkBookmark "uptime-kuma" "https://uptime-kuma.sua.sh")
                (mkBookmark "vaultwarden" "https://vaultwarden.sua.sh")
                (mkBookmark "wastebin" "https://wastebin.sua.sh")
              ];
            }
            {
              name = "email";
              bookmarks = [
                (mkBookmark "gmail" "https://mail.google.com")
                (mkBookmark "proton" "https://mail.proton.me")
              ];
            }
            (mkBookmark "reddit" "https://reddit.com")
            (mkBookmark "hacker news" "https://news.ycombinator.com")
            {
              name = "nix";
              bookmarks = [
                (mkBookmark "nixpkgs" "https://search.nixos.org/packages")
                (mkBookmark "nixpkgs options" "https://search.nixos.org/options?")
                (mkBookmark "nix wiki" "https://wiki.nixos.org")
                (mkBookmark "home-manager options" "https://nix-community.github.io/home-manager/options.xhtml")
                (mkBookmark "home-manager extranix options" "https://home-manager-options.extranix.com/")
                (mkBookmark "noogle" "https://noogle.dev/")
                (mkBookmark "nixvim" "https://nix-community.github.io/nixvim/")
                (mkBookmark "nixvim search" "https://nix-community.github.io/nixvim/search/")
                (mkBookmark "nix2json webui" "https://json-to-nix.pages.dev")
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
      packages = with pkgs.firefox-addons; [
        betterttv # twitch [dot] tv integration
        bitwarden # bit/vault warden password integration
        darkreader # automatic dark mode
        ublock-origin # block ads
        unpaywall # read research papers for free
        vimium # vim-like movements
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
          urls = [ { template = "https://searxng.sua.sh/search?q={searchTerms}"; } ];
          iconMapObj."16" = "https://searxng.sua.sh/favicon.ico";
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
        (mkBookmark "wikipedia" "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go")
        (mkBookmark "kernel.org" "https://www.kernel.org")
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
