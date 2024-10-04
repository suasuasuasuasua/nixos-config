{
  pkgs,
  lib,
  user,
  ...
}: {
  dconf = {
    enable = true;
    settings = let
      inherit (lib.hm.gvariant) mkValue mkVariant mkArray mkEmptyArray mkTuple mkString mkBoolean;
    in {
      # Change the desktop interface
      "org/gnome/desktop/interface" = {
        show-battery-percentage = true;
        color-scheme = "prefer-dark";

        monospace-font-name = "JetBrainsMono Nerd Font 10";
      };

      # TODO: figure out the stupid gVariant bs
      # "org/gnome/mutter/dynamic-workspaces" = (mkString true);

      # favorite-apps=['org.gnome.Nautilus.desktop', 'firefox.desktop', 'Alacritty.desktop', 'thunderbird.desktop', 'obsidian.desktop', 'eleme       nt-desktop.desktop', 'discord.desktop']

      # # Define the apps on the dock
      # "org/gnome/shell/favorite-apps" =
      # mkArray [
      # "org.gnome.Nautilus.desktop"
      # "firefox.desktop"
      # "spotify.desktop"
      # "Alacritty.desktop"
      # "thunderbird.desktop"
      # "obsidian.desktop"
      # "element-desktop.desktop"
      # ];

      # Enable extensions
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          tray-icons-reloaded.extensionUuid
          open-bar.extensionUuid
        ];
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
