{
  homebrew = {
    enable = true;
    onActivation = {
      # don't upgrade automatically -- let's do manual brew upgrades
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
      xcode = 497799835; # macOS, iOS, etc. IDE

      # entertainment
      audible-audio-entertainment = 379693831; # audible client
      amazon-kindle = 302584613; # kindle client

      # productivity
      flow-focus-pomodoro-timer = 1423210932; # pomodoro timer
      imovie = 408981434; # apple movie editor and maker
      keynote = 409183694; # apple presentation suite
      notability-smarter-ai-notes = 360593530; # note taking app
      numbers = 409203825; # apple spreadsheet application
      pages = 409201541; # apple word processing application
      tot = 1491071483; # daily note and task tracker

      # utility
      dark-reader-for-safari = 1438243180; # dark mode for safari
      hidden-bar = 1452453066; # macOS menubar organizer
      magnet = 441258766; # macOS workspace organizer
      # vimari = ""  # TODO: gone from mac app store?
    };
  };
}
