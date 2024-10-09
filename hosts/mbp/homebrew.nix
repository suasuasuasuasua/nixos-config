{
  nix-homebrew,
  user,
  ...
}: {
  nix-homebrew = {
    enable = true;
    # Apple Silicon Only
    enableRosetta = true;
    # User owning the Homebrew prefix
    user = "${user.name}";

    # Migrate any existing brew configurations
    autoMigrate = true;
    # Delete any brew packages that don't belong to nix
    onActivation.cleanup = "zap";
  };
}
