# Review about:config
{
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

  # QOL
  "browser.aboutConfig.showWarning" = false;
  "browser.warnOnQuit" = false;
  "browser.ml.chat.sidebar" = false;
}
