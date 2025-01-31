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
      #"use sendfile" = "yes";
      #"max protocol" = "smb2";
      # note: localhost is the ipv6 localhost ::1
      "hosts allow" = "192.168.0. 127.0.0.1 localhost";
      "hosts deny" = "0.0.0.0/0";
      "guest account" = "nobody";
      "map to guest" = "bad user";
    };
    # Music videos and audio!
    music = {
      "path" = "/zshare/media/music";
      "browseable" = "yes";
      "read only" = "no";
      "guest ok" = "yes";
      "create mask" = "0644";
      "directory mask" = "0755";
      # remember to create the samba group and add recursive permissions!
      "force group" = "samba";
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
