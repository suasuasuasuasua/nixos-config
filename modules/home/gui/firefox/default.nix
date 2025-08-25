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
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.firefox;
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
      MOZ_ENABLE_WAYLAND = "1";
    };

    programs.firefox = {
      inherit (cfg) package;
      inherit profiles policies;

      enable = true;
    };
  };
}
