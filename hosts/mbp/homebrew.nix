{
  homebrew = {
    enable = true;

    brews = [
      "mas"

      "ollama"
    ];
    casks = [
      "firefox"
      "raycast"

      "element"

      "visual-studio-code"
      "github"
      "docker"

      "shottr"
      "iina"
      "stats"

      "adguard"
      "logi-options+"
      "scroll-reverser"
    ];
    masApps = {
      "XCode" = 497799835;
      "Vimari" = 1480933944;
      "Hidden Bar" = 1452453066;
      "Magnet" = 441258766;
    };
    onActivation.cleanup = "zap";
  };
}
