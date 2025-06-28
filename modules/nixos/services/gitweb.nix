{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "gitweb";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Distributed version control system
    '';
    projectroot = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      gitweb = {
        inherit (cfg) projectroot;
        extraConfig = ''
          $feature{'blame'}{'default'} = [1];
          $feature{'ctags'}{'default'} = [1];
          $feature{'highlight'}{'default'} = [1];
        '';
      };

      nginx = {
        gitweb = {
          enable = true;
          location = "/gitweb";
          virtualHost = "${hostName}.${domain}";
        };

        # add SSL
        virtualHosts = {
          "${hostName}.${domain}" = {
            enableACME = true;
            forceSSL = true;
            acmeRoot = null;
          };
        };
      };
    };

    environment.systemPackages = [
      pkgs.highlight
    ];

    systemd = {
      timers."update-github-repos" = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          Persistent = true;
          # NOTE: run daily
          # OnCalendar = "daily";
          OnBootSec = "5m";
          OnUnitActiveSec = "5m";
          Unit = "update-github-repos.service";
        };
      };

      services."update-github-repos" = {
        path = with pkgs; [
          git
          openssh
        ];
        # NOTE: this errors...but it is successful in pulling the repos
        script =
          let
            repo_dir = "suasuasuasuasua";
          in
          # bash
          ''
            # Pull all repos in the directory
            find ${repo_dir} -maxdepth 1 -type d | xargs -P10 -I{} git -C {} pull

            # Exit gracefully
            exit 0
          '';
        serviceConfig = {
          Type = "oneshot";
          User = "justinhoang";
          WorkingDirectory = cfg.projectroot;
        };
      };
    };
  };
}
