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
    # Personal data
    personal = {
      "path" = "/zshare/personal/";
      "browseable" = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "username";
      "force group" = "groupname";
    };
    # Videos, movies, etc.
    media = {
      "path" = "/zshare/media/";
      "browseable" = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "username";
      "force group" = "groupname";
    };
    # Project space
    projects = {
      "path" = "/zshare/projects/";
      "browseable" = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "username";
      "force group" = "groupname";
    };
    # Recordings, images, screenshots, etc.
    captures = {
      "path" = "/zshare/captures/";
      "browseable" = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "username";
      "force group" = "groupname";
    };
    # Development files space -- isos
    dev = {
      "path" = "/zshare/dev/";
      "browseable" = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "username";
      "force group" = "groupname";
    };
    # macOS time machine share
    tm_share = {
      "path" = "/zshare/tm_share";
      "valid users" = "justinhoang";
      "public" = "no";
      "writeable" = "yes";
      "force user" = "justinhoang";
      "fruit:aapl" = "yes";
      "fruit:time machine" = "yes";
      "vfs objects" = "catia fruit streams_xattr";
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
