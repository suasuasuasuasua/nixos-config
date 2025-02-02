{
  services.glances = {
    enable = true;
    port = 61208;
    openFirewall = true;
    extraArgs = [
      "--webserver"
    ];
  };
}
