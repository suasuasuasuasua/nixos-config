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
      # TODO: figure out profiles
      profiles.personal = {
        inherit settings;

        id = 0;
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
        # TODO: add firefox extensions
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          betterttv
          ublock-origin
          vimium
        ];
      };
      profiles.productivity = {
        inherit settings;

        id = 1;
      };
    };
  };
}
