{pkgs, ...}: {
  # Install the obsidian webgui
  environment.systemPackages = with pkgs; [
    obsidian
  ];
}
