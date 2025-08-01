{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix
    # for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = "justinhoang";

    # Automatically migrate existing Homebrew installations
    autoMigrate = true;

    # Optional: Declarative tap management
    taps = with inputs; {
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-core" = homebrew-core;
    };

    # Optional: Enable fully-declarative tap management
    #
    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    onActivation = {
      # don't upgrade automatically -- let's do manual brew upgrades
      upgrade = false;
      autoUpdate = false;
      # uninstall brew apps not specified here
      cleanup = "zap";
    };

    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [
      {
        name = "syncthing"; # decentralized file synchronization
        start_service = true;
        restart_service = "changed";
      }
      {
        name = "ollama"; # llm runner and manager
        start_service = true;
        restart_service = "changed";
      }
    ];

    casks = [
      "adguard" # ad blocker
      "balenaetcher" # iso writer (*)
      "docker" # container runner and manager
      "kdenlive" # linear video editor
      "logi-options+" # logitech peripherals
      "obs" # studio recorder
      "proton-mail"
      "proton-mail-bridge"
      "raspberry-pi-imager" # imager for pi
      "scroll-reverser" # mouse util
    ];

    masApps = {
      amazon-kindle = 302584613; # kindle client
      amphetamine = 937984704; # powerful keep-awake utility
      audible-audio-entertainment = 379693831; # audible client
      dark-reader-for-safari = 1438243180; # dark mode for safari
      flow-focus-pomodoro-timer = 1423210932; # pomodoro timer
      imovie = 408981434; # apple movie editor and maker
      keynote = 409183694; # apple presentation suite
      magnet = 441258766; # macOS workspace organizer
      notability-smarter-ai-notes = 360593530; # note taking app
      numbers = 409203825; # apple spreadsheet application
      pages = 409201541; # apple word processing application
      tot = 1491071483; # daily note and task tracker
      wireguard = 1451685025; # VPN
      xcode = 497799835; # macOS, iOS, etc. IDE
    };
  };
}
