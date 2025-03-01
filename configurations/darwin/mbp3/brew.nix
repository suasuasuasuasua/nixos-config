{
  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
      autoUpdate = false;
      # uninstall brew apps not specified here
      cleanup = "zap";
    };

    taps = [
      "homebrew/services"
    ];
    brews = [
      "asimov" # time machine file ignorer (remember to start service!)
      "trash" # move files to the trash
    ];
    # TODO: look into using installing via nixpkgs or home manager
    # (*) brew only
    # (x) nixpkgs available
    casks = [
      # general
      "discord" # voice and text chat software (x)
      "element" # matrix platform client (x)
      "firefox" # web browser (x)
      "kdenlive" # linear video editor (x)
      "obsidian" # markdown based note-taking app (x)
      "obs" # studio recorder (x)
      "spotify" # music platform (x)

      # dev
      "docker" # docker desktop (includes cli) (*)
      "iterm2" # terminal emulator (x)
      "ollama" # llm manager (x)
      "visual-studio-code" # text editor (x)

      # games
      "battle-net" # another video game platform (*)
      "steam" # video game platform (x)

      # system and isos
      "balenaetcher" # iso writer (*)
      "raspberry-pi-imager" # imager for pi (*)
      "utm" # virtual machine manager (x)

      # utility
      "appcleaner" # app cleaner (cleans log/config files too) (x)
      "adguard" # ad blocker (*)
      "betterdisplay" # macos display configuration tool (*)
      "iina" # media player (x)
      "logi-options+" # logitech peripherals (*)
      "scroll-reverser" # mouse util (*)
      "shottr" # screenshot tool (*)
    ];
    masApps = {
      # dev
      xcode = 497799835;

      # utility
      dark-reader-safari = 1438243180;
      hiddenbar = 1452453066;
      magnet = 441258766;
      # vimari = ""  # TODO: gone from mac app store?
    };
  };
}
