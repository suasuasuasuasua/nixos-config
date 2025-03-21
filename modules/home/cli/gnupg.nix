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
    enable = lib.mkEnableOption "Enable gnupg";
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    services.gnome-keyring.enable = pkgs.stdenv.isLinux;
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;

      enableZshIntegration = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };
}
