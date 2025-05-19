{ pkgs, settings, ... }:
{
  personal = {
    inherit settings;

    id = 0;
    bookmarks = [
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
    # TODO: add configs for extensions
    #       for example, dark reader should follow system theme
    # https://nur.nix-community.org/repos/rycee/
    extensions = with pkgs.firefox-addons; [
      betterttv # twitch [dot] tv integration
      darkreader # automatic dark mode
      ublock-origin # block ads
      unpaywall # read research papers for free
      vimium # vim-like movements
    ];
  };
  productivity = {
    inherit settings;

    id = 1;
    bookmarks = [
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
}
