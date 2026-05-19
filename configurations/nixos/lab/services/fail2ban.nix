{ infra, ... }:
{
  services.fail2ban.jails.gitea.settings = {
    enabled = true;
    filter = "gitea";
    logpath = "/zshare/srv/gitea/log/gitea.log";
    action = ''
      %(action_)s geoip-log
    '';
    # Ignore the VPS0 WireGuard IP — it's a trusted reverse proxy, never a real attacker.
    # Even if Gitea logs 10.101.0.1 (e.g. due to proxy header misconfiguration),
    # banning it would cut off all public Gitea traffic.
    ignoreIP = "127.0.0.1/8 ${infra.vps0.wg1IP}/32";
  };

  environment.etc."fail2ban/filter.d/gitea.conf".text = ''
    [Definition]
    failregex = .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
    ignoreregex =
  '';
}
