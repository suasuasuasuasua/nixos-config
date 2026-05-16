locals {
  lab_ip = "192.168.0.240"
  pi_ip  = "192.168.0.250"
}

# ---------------------------------------------------------------------------
# Monitor groups
# ---------------------------------------------------------------------------

resource "uptimekuma_monitor_group" "public" {
  name = "Public"
}

resource "uptimekuma_monitor_group" "pi" {
  name = "Pi"
}

resource "uptimekuma_monitor_group" "lab" {
  name = "Lab"
}

# ---------------------------------------------------------------------------
# Public — internet-facing services via VPS proxy
# ---------------------------------------------------------------------------

resource "uptimekuma_monitor_http" "sua_dev" {
  name   = "sua.dev"
  url    = "https://sua.dev"
  parent = uptimekuma_monitor_group.public.id
}

resource "uptimekuma_monitor_http" "gitea" {
  name   = "Gitea"
  url    = "https://gitea.sua.dev"
  parent = uptimekuma_monitor_group.public.id
}

resource "uptimekuma_monitor_http" "headscale" {
  name   = "Headscale"
  url    = "https://hs.sua.dev"
  parent = uptimekuma_monitor_group.public.id
}

resource "uptimekuma_monitor_http" "uptime_kuma_public" {
  name   = "Uptime Kuma"
  url    = "https://uptime-kuma.sua.dev"
  parent = uptimekuma_monitor_group.public.id
}

# ---------------------------------------------------------------------------
# Pi — services on the Raspberry Pi (192.168.0.250)
# ---------------------------------------------------------------------------

resource "uptimekuma_monitor_http" "adguardhome" {
  name   = "AdGuard Home"
  url    = "http://${local.pi_ip}:3000"
  parent = uptimekuma_monitor_group.pi.id
}

resource "uptimekuma_monitor_http" "uptime_kuma_internal" {
  name   = "Uptime Kuma (internal)"
  url    = "http://${local.pi_ip}:4000"
  parent = uptimekuma_monitor_group.pi.id
}

resource "uptimekuma_monitor_http" "glances_pi" {
  name   = "Glances (Pi)"
  url    = "http://${local.pi_ip}:61208"
  parent = uptimekuma_monitor_group.pi.id
}

# ---------------------------------------------------------------------------
# Lab — services on the lab machine (192.168.0.240)
# ---------------------------------------------------------------------------

resource "uptimekuma_monitor_http" "actual" {
  name   = "Actual Budget"
  url    = "http://${local.lab_ip}:3000"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "audiobookshelf" {
  name   = "Audiobookshelf"
  url    = "http://${local.lab_ip}:8000"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "calibre" {
  name   = "Calibre Web"
  url    = "http://${local.lab_ip}:8083"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "gitea_internal" {
  name   = "Gitea (internal)"
  url    = "http://${local.lab_ip}:3001"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "glances_lab" {
  name   = "Glances (Lab)"
  url    = "http://${local.lab_ip}:61208"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "grafana" {
  name   = "Grafana"
  url    = "http://${local.lab_ip}:3005"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "home_assistant" {
  name   = "Home Assistant"
  url    = "http://${local.lab_ip}:8123"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "immich" {
  name   = "Immich"
  url    = "http://${local.lab_ip}:2283"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "it_tools" {
  name   = "IT Tools"
  url    = "http://${local.lab_ip}:8085"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "jellyfin" {
  name   = "Jellyfin"
  url    = "http://${local.lab_ip}:8096"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "linkwarden" {
  name   = "Linkwarden"
  url    = "http://${local.lab_ip}:3004"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "mealie" {
  name   = "Mealie"
  url    = "http://${local.lab_ip}:9000"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_tcp_port" "minecraft" {
  name     = "Minecraft"
  hostname = local.lab_ip
  port     = 25565
  parent   = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "navidrome" {
  name   = "Navidrome"
  url    = "http://${local.lab_ip}:4533"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "paperless" {
  name   = "Paperless"
  url    = "http://${local.lab_ip}:28981"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "prometheus" {
  name   = "Prometheus"
  url    = "http://${local.lab_ip}:9090"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "searxng" {
  name   = "SearXNG"
  url    = "http://${local.lab_ip}:8084"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "stirling_pdf" {
  name   = "Stirling PDF"
  url    = "http://${local.lab_ip}:8081"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "syncthing" {
  name   = "Syncthing"
  url    = "http://${local.lab_ip}:8384"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "termix" {
  name   = "Termix"
  url    = "http://${local.lab_ip}:8086"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "vaultwarden" {
  name   = "Vaultwarden"
  url    = "http://${local.lab_ip}:8222"
  parent = uptimekuma_monitor_group.lab.id
}

resource "uptimekuma_monitor_http" "wastebin" {
  name   = "Wastebin"
  url    = "http://${local.lab_ip}:8088"
  parent = uptimekuma_monitor_group.lab.id
}
