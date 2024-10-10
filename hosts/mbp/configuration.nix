{
  pkgs,
  lib,
  config,
  user,
  ...
}: {
  # TODO: fill this in!

  imports = [
    ./homebrew.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    git

    gnutar
    gnumake
    curl
    wget
    zip
    unzip

    clang
    ripgrep

    mkalias

    fastfetch
    onefetch
  ];

  # General related settings
  system.defaults = {
    dock.autohide = true;
    dock.persistent-apps = [
      "/System/Applications/Launchpad.app/"
      "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Calendar.app"
      "/System/Applications/Reminders.app"
      "/System/Applications/News.app"
      "/Applications/Firefox.app"
    ];

    # Delay before keys are repeated
    NSGlobalDomain.InitialKeyRepeat = 10;
    # Repeat speed
    NSGlobalDomain.KeyRepeat = 5;

    WindowManager.AutoHide = true;

    # Don't sort the spaces by most recently used
    dock.mru-spaces = false;
    # Don't show recent apps in the bottom bar
    dock.show-recents = false;

    # Silent clicking
    trackpad.ActuationStrength = 0;
  };

  # Keyboard related settings
  system.keyboard = {
    enableKeyMapping = true;

    # Swap the control and globe key
    swapLeftCtrlAndFn = true;
  };

  # Nix-darwin does not link installed applications to the user environment. This means apps will not show up
  # in spotlight, and when launched through the dock they come with a terminal window. This is a workaround.
  # Upstream issue: https://github.com/LnL7/nix-darwin/issues/214
  system.activationScripts.applications.text = lib.mkForce ''
    echo "setting up ~/Applications..." >&2
    applications="$HOME/Applications"
    nix_apps="$applications/Nix Apps"

    # Needs to be writable by the user so that home-manager can symlink into it
    if ! test -d "$applications"; then
        mkdir -p "$applications"
        chown ${user.name}: "$applications"
        chmod u+w "$applications"
    fi

    # Delete the directory to remove old links
    rm -rf "$nix_apps"
    mkdir -p "$nix_apps"

    find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read src; do
            # Spotlight does not recognize symlinks, it will ignore directory we link to the applications folder.
            # It does understand MacOS aliases though, a unique filesystem feature. Sadly they cannot be created
            # from bash (as far as I know), so we use the oh-so-great Apple Script instead.
            /usr/bin/osascript -e "
                set fileToAlias to POSIX file \"$src\"
                set applicationsFolder to POSIX file \"$nix_apps\"
                tell application \"Finder\"
                    make alias file to fileToAlias at applicationsFolder
                    # This renames the alias; 'mpv.app alias' -> 'mpv.app'
                    set name of result to \"$(rev <<< "$src" | cut -d'/' -f1 | rev)\"
                end tell
            " 1>/dev/null
        done
  '';

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true; # default shell on catalina

  # # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.extraOptions = ''
    trusted-users = root ${user.name}
  '';

  fonts.packages = [
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];
}
