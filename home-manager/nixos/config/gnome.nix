{
  dconf = {
    enable = true;
    settings = {
      # Change the desktop interface
      "/org/gnome/desktop/interface" = {
        show-battery-percentage = true;
        color-scheme = "prefer-dark";

        monospace-font-name = "JetBrainsMono Nerd Font 10";
      };

      # Define the apps on the dock
      "/org/gnome/shell/favorite-apps" = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "spotify.desktop"
        "Alacritty.desktop"
        "thunderbird.desktop"
        "obsidian.desktop"
      ];
    };
  };
}
