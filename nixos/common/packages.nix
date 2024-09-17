{pkgs, ...}: {
  fonts.packages = with pkgs; [(nerdfonts.override {fonts = ["JetBrainsMono"];})];

  environment.systemPackages = with pkgs; [
    # General
    git
    zip
    unzip
    wget
    curl
    tree-sitter
    ripgrep
    fd
    lshw

    # Languages, Compilers, and Toolchains
    gnumake
    gcc
    lua
    luarocks
    go
    python3
    nodejs
    rustup

    # System monitoring
    fastfetch
    btop
    timeshift

    # File Viewing
    zathura
    yazi

    # Copy and paste
    wl-clipboard
  ];
}
