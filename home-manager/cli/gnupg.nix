{pkgs, ...}: {
  services.gnome-keyring.enable = true;
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;

    enableZshIntegration = true;
    enableSshSupport = true;

    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
