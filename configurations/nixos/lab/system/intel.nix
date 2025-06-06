# https://wiki.nixos.org/wiki/Jellyfin
# https://nixos.wiki/wiki/Intel_Graphics
{ pkgs, ... }:
{
  # 1. enable vaapi on OS-level
  nixpkgs.config.packageOverrides = pkgs: {
    # Only set this if using intel-vaapi-driver
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD"; # Or "i965" if using older driver
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  }; # Same here

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
      libva-vdpau-driver # Previously vaapiVdpau
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
      # intel-ocl # OpenCL support
    ];
  };
}
