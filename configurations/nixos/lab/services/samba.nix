{
  # Personal things
  personal = {
    "path" = "/zshare/personal";
    "browseable" = "yes";
    "valid users" = "justinhoang";
    "public" = "no";
    "read only" = "no";
    "create mask" = "0644";
    "directory mask" = "0755";
    # remember to create the samba group and add recursive permissions!
    "force group" = "samba";
  };
  # Backups
  tm_share = {
    "path" = "/zshare/backup/tm_share";
    "valid users" = "justinhoang";
    "public" = "no";
    "writeable" = "yes";
    "force group" = "samba";
    "fruit:aapl" = "yes";
    "fruit:time machine" = "yes";
    "vfs objects" = "catia fruit streams_xattr";
  };
  # Projects
  projects = {
    "path" = "/zshare/projects";
    "valid users" = "justinhoang";
    "browseable" = "yes";
    "public" = "no";
    "read only" = "no";
    "create mask" = "0644";
    "directory mask" = "0755";
    # remember to create the samba group and add recursive permissions!
    "force group" = "samba";
  };
  # Served content
  srv = {
    "path" = "/zshare/srv";
    "valid users" = "justinhoang";
    "browseable" = "yes";
    "public" = "no";
    "read only" = "no";
    "create mask" = "0644";
    "directory mask" = "0755";
    # remember to create the samba group and add recursive permissions!
    "force group" = "samba";
  };
  # Music videos and audio!
  media = {
    "path" = "/zshare/media";
    "valid users" = "justinhoang";
    "browseable" = "yes";
    "public" = "no";
    "read only" = "no";
    "create mask" = "0644";
    "directory mask" = "0755";
    # remember to create the samba group and add recursive permissions!
    "force group" = "samba";
  };
  # Temp!
  tmp = {
    "path" = "/ztmp/tmp";
    "valid users" = "justinhoang";
    "browseable" = "yes";
    "public" = "no";
    "read only" = "no";
    "create mask" = "0644";
    "directory mask" = "0755";
    # remember to create the samba group and add recursive permissions!
    "force group" = "samba";
  };
}
