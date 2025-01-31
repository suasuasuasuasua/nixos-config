{
  services.samba = {
    enable = true;
    openFirewall = true;
  };

  services.samba.settings = {
    global = {
      "workgroup" = "WORKGROUP";
      "server string" = "smbnix";
      "netbios name" = "smbnix";
      "security" = "user";
    };
    # Videos, movies, etc.
    media = {
      "path" = "/zshare/media/";
      "browseable" = "yes";
      "read only" = "no";
      "writeable" = "yes";
      "guest ok" = "yes";
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
