{ pkgs, ... }: {
  programs.obs-studio = {
    enable = true;

    # Add any plugins for OBS studio
    plugins = with pkgs.obs-studio-plugins; [
    ];

    # TODO: many options for OBS
  };
}
