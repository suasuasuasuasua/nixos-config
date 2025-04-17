{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.cli.gnupg;
in
{
  options.home.cli.gnupg = {
    enable = lib.mkEnableOption ''
      Modern release of the GNU Privacy Guard, a GPL OpenPGP implementation
    '';
  };

  config = lib.mkIf cfg.enable {
    services.gnome-keyring.enable = pkgs.stdenv.isLinux;
    programs.gpg = {
      enable = true;
      settings = {
        pinentry-mode = "loopback";
      };
    };

    services.gpg-agent = {
      enable = true;

      enableZshIntegration = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-curses;

      # config for signing in neovim
      defaultCacheTtl = 28800; # increase time before entering password
      maxCacheTtl = 28800;
      extraConfig = ''
        allow-loopback-pinentry
      '';
    };
  };
}
