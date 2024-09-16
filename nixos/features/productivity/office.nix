{pkgs, ...}: {
  # # Libre Office
  # environment.systemPackages = with pkgs; [
  #   libreoffice-qt
  #   hunspell
  #   hunspellDicts.us_EN
  # ];

  # # Only Office
  environment.systemPackages = with pkgs; [
    onlyoffice-bin
  ];
}
