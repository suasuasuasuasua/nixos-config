{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.home.gui.firefox;

  settings = import ./settings.nix;
  profiles = import ./profiles.nix {
    inherit lib pkgs settings;
  };
  policies = import ./policies.nix;
in
{
  options.custom.home.gui.firefox = {
    enable = lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
      MOZ_ENABLE_WAYLAND = "1";
    };

    programs.firefox = {
      inherit profiles policies;

      enable = true;
    };
  };
}
