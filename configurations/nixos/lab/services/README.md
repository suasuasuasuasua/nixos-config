# Services

## Workflow

1. Write a new service module (`.nix` file)
1. Add the file to the `default.nix` import list
1. Add the service name to the DNS rewrites
   - Currently managed on the raspberry pi's AdGuard Home instance
1. Profit!

## Debugging

1. Did you open the correct ports? Check the firewall...
1. Is there an entry in the DNS for the service URL?
1. Did the DNS fully propagatate the ACME challenge?
1. Are you referencing the correct path for `sops`?

## Ports

- 22 (ssh)
- 80 (nginx)
- 443 (nginx)
- 2283 (immich)
- 3000 (actual)
- 3001 (gitea)
- 3002 (hydra)
- 3003 (grafana)
- 3004 (linkwarden)
- 4533 (navidrome)
- 5000 (firefox syncserver)
- 5353 (avahi)
- 8000 (audiobookshelf)
- 8080 (calibre server)
- 8081 (stirling-pdf)
- 8082 (open-webui)
- 8083 (calibre web)
- 8084 (searxng)
- 8085 (it-tools)
- 8088 (wastebin)
- 8096 (jellyfin)
- 8123 (home-assistant)
- 8222 (vaultwarden)
- 8384 (syncthing)
- 9000 (mealie)
- 9001 (miniflux)
- 9090 (prometheus)
- 9100 (node-exporter)
- 9113 (nginx-exporter)
- 9134 (zfs-exporter)
- 9586 (wireguard-exporter)
- 11434 (ollama)
- 28981 (paperless)
- 51820 (wireguard)
- 61208 (glances)readme
