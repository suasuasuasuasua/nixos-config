{ pkgs, ... }: {
  services.gnome-keyring.enable = pkgs.stdenv.isLinux;
  programs.gpg.enable = true;

  home.packages = (
    [ pkgs.pinentry-curses ] ++
    (if pkgs.stdenv.isDarwin then [
      pkgs.pinentry_mac
    ] else [
      pkgs.pinentry-gnome3
    ])
  );

  services.gpg-agent = {
    enable = true;

    enableZshIntegration = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
