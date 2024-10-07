{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # General
    git
    gibo

    zip
    unzip
    wget
    curl

    tree-sitter
    ripgrep
    fd
    lshw

    wl-clipboard

    # System monitoring
    fastfetch
    onefetch
    btop
    timeshift
    speedtest-cli
  ];
}
