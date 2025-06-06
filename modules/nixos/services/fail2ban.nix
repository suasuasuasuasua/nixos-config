{
  config,
  lib,
  ...
}:
let
  serviceName = "fail2ban";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Program that scans log files for repeated failing login attempts and bans
      IP addresses
    '';
  };

  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;

      # Ban IP after 10 failures
      maxretry = 10;

      bantime = "24h"; # Ban IPs for one day on the first ban
      bantime-increment = {
        enable = true; # Enable increments of bantime after each violation
        # Choose the formula or the multipliers
        # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h"; # Do not ban for more than 1 week
        overalljails = true; # Calculate the bantime based on all the violations
      };

      jails = {
        apache-nohome-iptables.settings = {
          # Block an IP address if it accessed a non-existent home directory
          # more than 5 times in 10 minutes since that indicates that it's
          # scanning
          filter = "apache-nohome";
          action = ''iptables-multiport[name=HTTP, port="http,https"]'';
          logpath = "/var/log/httpd/error_log*";
          backend = "auto";
          findtime = 600;
          bantime = 600;
          maxretry = 5;
        };
      };
    };
  };
}
