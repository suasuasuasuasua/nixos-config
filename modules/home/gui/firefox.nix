{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;

  cfg = config.home.gui.firefox;
in
{
  options.home.gui.firefox = {
    enable = lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # TODO: figure out profiles
      policies = { };
      profiles = {
        justinhoang = {
          name = "default";
          id = 0;
          search = {
            default = "Google";
          };
          # TODO: research settings
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
          containers = {
            personal = {
              color = "red";
              icon = "fingerprint";
              id = 1;
            };
            coding = {
              color = "green";
              icon = "briefcase";
              id = 2;
            };
            shopping = {
              color = "blue";
              icon = "cart";
              id = 3;
            };
          };
          # TODO: add firefox extensions
          extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
            betterttv
            ublock-origin
            vimium
          ];
        };
      };
    };
  };
}
