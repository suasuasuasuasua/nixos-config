{ pkgs, settings, ... }:
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
            {
              name = "youtube";
              url = "https://youtube.com/";
            }
            {
              name = "gmail";
              url = "https://mail.google.com/";
            }
            {
              name = "proton";
              bookmarks = [
                {
                  name = "mail";
                  url = "https://mail.proton.me";
                }
                {
                  name = "calendar";
                  url = "https://calendar.proton.me";
                }
              ];
            }
            {
              name = "reddit";
              url = "https://reddit.com/";
            }
            {
              name = "hacker news";
              url = "https://news.ycombinator.com/";
            }
            {
              name = "nix";
              bookmarks = [
                {
                  name = "nixpkgs";
                  url = "https://search.nixos.org/packages";
                }
                {
                  name = "nixpkgs options";
                  url = "https://search.nixos.org/options?";
                }
                {
                  name = "nix-darwin";
                  url = "https://nix-darwin.github.io/nix-darwin/manual/index.html";
                }
                {
                  name = "home-manager options";
                  url = "https://nix-community.github.io/home-manager/options.xhtml";
                }
                {
                  name = "home-manager extranix options";
                  url = "https://home-manager-options.extranix.com/";
                }
                {
                  name = "noogle";
                  url = "https://noogle.dev/";
                }
                {
                  name = "nixvim";
                  url = "https://nix-community.github.io/nixvim/";
                }
                {
                  name = "nixvim search";
                  url = "https://nix-community.github.io/nixvim/search/";
                }
                {
                  name = "nix2json webui";
                  url = "https://json-to-nix.pages.dev";
                }
              ];
            }
            {
              name = "macOS";
              bookmarks = [
                {
                  name = "brew";
                  url = "https://brew.sh/";
                }
              ];
            }
          ];
        }
      ];
    };
    extensions = {
      force = true;
      packages = with pkgs.firefox-addons; [
        betterttv # twitch [dot] tv integration
        darkreader # automatic dark mode
        ublock-origin # block ads
        unpaywall # read research papers for free
        vimium # vim-like movements
      ];
      # https://nur.nix-community.org/repos/rycee/
      # about:debugging#/runtime/this-firefox
      # or export settings and view json
      settings = {
        # Example with uBlock origin's extensionID
        "addon@darkreader.org".settings = {
          # follow system theme
          automation = {
            enabled = true;
            mode = "system";
            behavior = "OnOff";
          };
        };
        "firefox@betterttv.net".settings = {
          # auto-claim channel points and drops
          "autoClaim" = [
            1
            1
          ];
          # add 7tv
          "emotes" = [
            55
            16
          ];
        };
        "uBlock0@raymondhill.net".settings = {
          # add filter lists
          selectedFilterLists = [
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"
            "easylist"
            "adguard-generic"
            "adguard-mobile"
            "easyprivacy"
          ];
        };
        # vimium
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}".settings = {
          exclusionRules = [
            {
              passKeys = "";
              pattern = "https?://mail.google.com/*";
            }
            {
              passKeys = "/";
              pattern = "https?://www.google.com/*";
            }
          ];
        };
      };
    };
  };
  productivity = {
    inherit settings;

    id = 1;
    bookmarks = {
      force = true;
      settings = [
        {
          name = "wikipedia";
          tags = [ "wiki" ];
          keyword = "wiki";
          url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
        }
        {
          name = "kernel.org";
          url = "https://www.kernel.org";
        }
        {
          name = "Nix sites";
          toolbar = true;
          bookmarks = [
            {
              name = "homepage";
              url = "https://nixos.org/";
            }
            {
              name = "wiki";
              tags = [
                "wiki"
                "nix"
              ];
              url = "https://wiki.nixos.org/";
            }
          ];
        }
      ];
    };
  };
}
