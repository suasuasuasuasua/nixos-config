{
  services.jellyfin = {
    enable = true;
    # no option to change port...
    # port = 8096
    openFirewall = true;
  };
}
