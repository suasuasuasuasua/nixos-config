{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    obsidian
    onlyoffice-bin
    # TODO: figure out if onlyoffice is better than libreoffice (it looks better
    # anyway)
    # libreoffice-qt
    # hunspell
    # hunspellDicts.en_US
  ];
}
