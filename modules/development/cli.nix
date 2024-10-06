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

    # System monitoring
    fastfetch
    btop
    timeshift
    speedtest-cli
  ];
}
