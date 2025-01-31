{
  services.gitweb = {
    projectroot = "/srv/git"; # default path
  };
  services.nginx.gitweb.enable = true;
}
