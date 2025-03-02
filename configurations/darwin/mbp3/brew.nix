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
      "ollama" # llm runner and manager
      "trash" # move files to the trash
    ];
    casks = [
      # dev
      "docker" # docker desktop (includes cli)

      # general
      "firefox" # web browser
      "kdenlive" # linear video editor
      "obs" # studio recorder

      # games
      "battle-net" # another video game platform

      # system and isos
      "balenaetcher" # iso writer (*)
      "raspberry-pi-imager" # imager for pi

      # utility
      "adguard" # ad blocker
      "betterdisplay" # macos display configuration tool
      "logi-options+" # logitech peripherals
      "scroll-reverser" # mouse util
      "shottr" # screenshot tool
    ];
    masApps = {
      # dev
      xcode = 497799835;

      # entertainment
      audible-audio-entertainment = 379693831;
      amazon-kindle = 302584613;

      # productivity
      flow-focus-pomodoro-timer = 1423210932;
      imovie = 408981434;
      keynote = 409183694;
      notability-smarter-ai-notes = 360593530;
      numbers = 409203825;
      pages = 409201541;
      tot = 1491071483;

      # utility
      dark-reader-for-safari = 1438243180;
      hidden-bar = 1452453066;
      magnet = 441258766;
      # vimari = ""  # TODO: gone from mac app store?
    };
  };
}
