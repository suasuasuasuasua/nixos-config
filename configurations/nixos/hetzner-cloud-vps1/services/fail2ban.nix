# fail2ban monitors log files looking for suspicious activity like brute force
# attempts to login. it can ban ip addresses for a certain amount of time (hence
# the jail)
{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.geoip ];

  # Custom action: logs country info to the systemd journal on ban
  environment.etc."fail2ban/action.d/geoip-log.conf".text = ''
    [Definition]
    actionban = geoiplookup <ip> | systemd-cat -t fail2ban-geo -p warning
    actionunban =
  '';

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

    jails.sshd.settings = {
      enabled = true;
      # %(action_)s is the default ban action; geoip-log runs alongside it
      action = ''
        %(action_)s geoip-log
      '';
    };
  };
}
