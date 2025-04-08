{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.home.gui.firefox;

  settings = {
    # Enable HTTPS-Only Mode
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_ever_enabled" = true;

    # Disable updates (pretty pointless with nix)
    "app.update.channel" = "default";

    # Privacy settings
    "privacy.donottrackheader.enabled" = true;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.partition.network_state.ocsp_cache" = true;

    # Disable all sorts of telemetry
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.ping-centre.telemetry" = false;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.hybridContent.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.updatePing.enabled" = false;

    # As well as Firefox 'experiments'
    "experiments.activeExperiment" = false;
    "experiments.enabled" = false;
    "experiments.supported" = false;
    "network.allow-experiments" = false;

    # Disable Pocket Integration
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
    "extensions.pocket.enabled" = false;
    "extensions.pocket.api" = "";
    "extensions.pocket.oAuthConsumerKey" = "";
    "extensions.pocket.showHome" = false;
    "extensions.pocket.site" = "";

    # Automatically enable extensions
    "extensions.autoDisableScopes" = 0;
  };
in
{
  options.home.gui.firefox = {
    enable = lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # TODO: firefox is in unstable for darwin...remove in may 2025
      package = with pkgs; if stdenv.isDarwin then unstable.firefox else firefox;

      # TODO: research policies: https://mozilla.github.io/policy-templates/
      policies = { };
      profiles.personal = {
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
                name = "reddit";
                url = "https://reddit.com/";
              }
              {
                name = "hacker news";
                url = "https://news.ycombinator.com/";
              }
              {
                name = "nix related";
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
                    name = "home-manager";
                    url = "https://home-manager-options.extranix.com/";
                  }
                  {
                    name = "nixvim";
                    url = "https://nix-community.github.io/nixvim/";
                  }
                ];
              }
            ];
          }
        ];
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          betterttv # twitch [dot] tv integration
          darkreader # automatic dark mode
          don-t-fuck-with-paste # prevent websites from modifying copy+paste
          edit-with-emacs # allow emacs-like editing in text fields
          octotree # better github
          reddit-enhancement-suite # better reddit
          seventv # another twitch add-on
          ublock-origin # block ads
          vimium # vim-like movements
        ];
      };
      profiles.productivity = {
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
    };
  };
}
