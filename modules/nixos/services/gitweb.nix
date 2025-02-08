{
  services.gitweb = {
    # TODO: make this a dynamic argument?
    # "/srv/git" is the default path
    projectroot = "/zshare/srv/git";
  };

  services.nginx.gitweb.enable = true;
}
