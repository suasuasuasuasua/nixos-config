{
  services.navidrome = {
    enable = true;
    openFirewall = true;

    settings = {
      Port = 4533;
      Address = "127.0.0.1";
      EnableInsightsCollector = false;

      MusicFolder = "/zshare/media/music";
    };
  };
}
