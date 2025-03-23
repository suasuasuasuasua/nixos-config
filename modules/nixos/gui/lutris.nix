{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.lutris;
in
{
  options.nixos.gui.lutris = {
    enable = lib.mkEnableOption "Enable Lutris";
    # TODO: add extra libraries and packages?
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (lutris.override {
        # extraLibraries = pkgs: [
        #   # List library dependencies here
        # ];
        # extraPkgs = pkgs: [
        #   # List package dependencies here
        # ];
      })
    ];
  };
}
