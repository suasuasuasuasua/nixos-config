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
    # TODO: look into using nixpkgs for starred (*) apps
    casks = [
      # general
      "discord" # voice and text chat software *
      "element" # matrix platform client *
      "firefox" # web browser *
      "kdenlive" # linear video editor *
      "obsidian" # markdown based note-taking app *
      "obs" # studio recorder *
      "spotify" # music platform *

      # dev
      "docker" # docker desktop (includes cli)
      "iterm2" # terminal emulator *
      "ollama" # llm manager *
      "visual-studio-code" # text editor *

      # games
      "battle-net" # another video game platform
      "steam" # video game platform *

      # system and isos
      "balenaetcher" # iso writer
      "raspberry-pi-imager" # imager for pi
      "utm" # virtual machine manager *

      # utility
      "appcleaner" # app cleaner (cleans log/config files too) *
      "adguard" # ad blocker
      "betterdisplay" # macos display configuration tool
      "iina" # media player *
      "logi-options+" # logitech peripherals
      "scroll-reverser" # mouse util
      "shottr" # screenshot tool
    ];
    masApps = {
      # utility
      DarkReaderSafari = 1438243180;
      Magnet = 441258766;
      # Vimari = ""  # TODO: gone from mac app store?
      # dev
      Xcode = 497799835;
    };
  };
}
