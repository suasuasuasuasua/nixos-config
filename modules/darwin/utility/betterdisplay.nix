{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.darwin.utility.betterdisplay;
in
{
  options.darwin.utility.betterdisplay = {
    enable = lib.mkEnableOption ''
      Unlock your displays on your Mac! Flexible HiDPI scaling, XDR/HDR extra
      brightness, virtual screens, DDC control, extra dimming, PIP/streaming,
      EDID override and lots more
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      betterdisplay
    ];
  };
}
