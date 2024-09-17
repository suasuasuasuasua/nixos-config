{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    onlyoffice-bin
    obsidian
    #   libreoffice-qt
    #   hunspell
    #   hunspellDicts.us_EN
  ];
}
