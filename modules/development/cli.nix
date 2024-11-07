{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # General
    git
    gibo

    # Files
    zip
    unzip
    wget
    curl

    tree-sitter
    ripgrep
    fd
    lshw
    just

    # Add markdown linter for neovim
    markdownlint-cli

    # Allow copy and paste in apps like neovim
    wl-clipboard

    # System monitoring
    fastfetch
    onefetch
    btop
    timeshift
    speedtest-cli
  ];
}
