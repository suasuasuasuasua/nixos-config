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
    enable = lib.mkEnableOption ''
      Open Source gaming platform for GNU/Linux
    '';
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
