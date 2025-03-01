{
  flake,
  config,
  lib,
  ...
}:
let
  inherit (flake) inputs;

  cfg = config.home.gui.firefox;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.home.gui.firefox = {
    enable = lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # TODO: figure out profiles
    };
  };
}
