{
  services.gitweb = {
    # projectroot = "/srv/git"; # default path
    projectroot = "/zshare/projects/git";
  };
  services.nginx.gitweb.enable = true;
}
