{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.steam;
in
{
  options.nixos.gui.steam = {
    enable = lib.mkEnableOption ''
      Digital distribution platform
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
