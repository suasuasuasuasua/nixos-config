{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  # https://github.com/nix-darwin/nix-darwin/issues/1314
  # https://github.com/nix-darwin/nix-darwin/pull/1329
  environment.systemPackages = with pkgs; [
    unstable.mas
  ];

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
      "ollama" # llm runner and manager
    ];

    casks = [
      # dev
      "docker" # container runner and manager

      # general
      "element" # chat
      "kdenlive" # linear video editor
      "obs" # studio recorder

      # system and isos
      "balenaetcher" # iso writer (*)
      "raspberry-pi-imager" # imager for pi

      # utility
      "adguard" # ad blocker
      "betterdisplay" # macos display configuration tool (TODO: nixpkgs unstable 25.05)
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
      amphetamine = 937984704; # powerful keep-awake utility
      dark-reader-for-safari = 1438243180; # dark mode for safari
      hidden-bar = 1452453066; # macOS menubar organizer
      magnet = 441258766; # macOS workspace organizer
    };
  };
}
