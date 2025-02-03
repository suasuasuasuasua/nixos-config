{
  services.dashy = {
    enable = true;
    # option does not exist :(
    # port = 8080;
    virtualHost.enableNginx = true;
    virtualHost.domain = "dashy.lab.home";

    settings = {
      appConfig = {
        enableFontAwesome = true;
        fontAwesomeKey = "e9076c7025";
        theme = "dashy-docs";
        layout = "vertical";
      };
      pageInfo = {
        description = "sua's homelab";
        navLinks = [
          {
            path = "/";
            title = "home";
          }
        ];
        title = "dashy";
        logo = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg";
      };
      # icon plug
      # - https://dashy.to/docs/icons/
      sections = [
        {
          name = "networking";
          displayData = {
            cols = 2;
            itemSize = "large";
          };
          items = [
            {
              title = "adguard";
              description = "adguard home dns blocker";
              icon = "hl-adguardhome";
              target = "sametab";
              url = "http://adguard.lab.home";
            }
          ];
        }
        {
          name = "monitoring";
          displayData = {
            cols = 2;
            itemSize = "large";
          };
          items = [
            {
              title = "glances";
              description = "system overview";
              icon = "hl-glances";
              target = "sametab";
              url = "http://glances.lab.home";
            }
          ];
        }
        {
          name = "productivity";
          displayData = {
            cols = 2;
            itemSize = "large";
          };
          items = [
            {
              title = "mealie";
              description = "recipe and meal tracker";
              icon = "hl-mealie";
              target = "sametab";
              url = "http://mealie.lab.home";
            }
            {
              title = "actual";
              description = "finance tracker";
              icon = "hl-actual";
              target = "sametab";
              url = "http://actual.lab.home";
            }
            {
              title = "gitweb";
              description = "gitweb server";
              icon = "si-git";
              target = "sametab";
              url = "http://lab.home/gitweb";
            }
          ];
        }
        {
          name = "media";
          displayData = {
            cols = 2;
            itemSize = "large";
          };
          items = [
            {
              title = "jellyfin";
              description = "media server";
              icon = "hl-jellyfin";
              target = "sametab";
              url = "http://jellyfin.lab.home";
            }
          ];
        }
      ];
    };
  };
}
