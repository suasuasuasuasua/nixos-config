# organice is a responsive web UI for org-mode files (view/edit tasks & notes).
# It's a static PWA that syncs against a WebDAV backend, which we scope to the
# Syncthing'd org tree so edits propagate to the other machines and nvim-orgmode.
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "organice";
in
{
  imports = [ ./compose.nix ];

  # WebDAV backend exposing the org tree. Runs as the file owner (justinhoang:samba)
  # so edits stay owned correctly and don't fight with Syncthing. No `users` block
  # => anonymous access (reachable only over the Tailnet, fronted by nginx).
  services.webdav = {
    enable = true;
    user = "justinhoang";
    group = "samba";
    settings = {
      address = "127.0.0.1";
      port = infra.ports.organice.webdav;
      prefix = "/dav";
      directory = "/zshare/personal/notes";
      permissions = "CRUD";
      behindProxy = true;
    };
  };
  # group-writable new files so Syncthing (also group samba) can modify them
  systemd.services.webdav.serviceConfig.UMask = "0002";

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];

    # organice static app
    locations."/".proxyPass = "http://127.0.0.1:${toString infra.ports.organice.app}";

    # WebDAV backend on the same origin -> no CORS needed. proxy_pass forwards
    # WebDAV methods (PROPFIND/PUT/MOVE/...) and the Depth header unchanged.
    locations."/dav".proxyPass = "http://127.0.0.1:${toString infra.ports.organice.webdav}";
  };
}
