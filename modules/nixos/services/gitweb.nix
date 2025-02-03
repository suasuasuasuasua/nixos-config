{
  services.gitweb = {
    # projectroot = "/srv/git"; # default path
    projectroot = "/zshare/srv/git";
  };
  services.nginx.gitweb.enable = true;
}
