{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;

    # Add any plugins for OBS studio
    plugins = with pkgs.obs-studio-plugins; [
    ];
  };

  # Add the CLI interface as well
  home.packages = with pkgs; [
    obs-cli
  ];
}
