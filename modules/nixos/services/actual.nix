{
  # TODO: need to setup HTTPS to continue using...
  services.actual = {
    enable = true;
    openFirewall = true;
    settings = {
      # default port is 3000
      port = 3001;
    };
  };
}
