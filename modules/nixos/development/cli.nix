{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Files
    zip
    unzip
    wget
    curl

    lshw

    # Allow copy and paste in apps like neovim
    wl-clipboard
  ];
}
