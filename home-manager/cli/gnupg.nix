{pkgs, ...}: {
  services.gnome-keyring.enable = true;
  programs.gpg.enable = true;

  home.packages = with pkgs; [
    pinentry-gnome3
  ];

  services.gpg-agent = {
    enable = true;

    enableZshIntegration = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
