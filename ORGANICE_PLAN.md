# Add organice (org-mode web UI) to the `lab` host

## Context

Justin keeps his tasks/notes as org files (`inbox.org`, `projects.org`, `journal.org`,
`notes/`, `archive/`) edited in Neovim with nvim-orgmode and a custom 6-block agenda
dashboard. On the go (phone via Termius over Tailscale), editing in vim is impractical.
He wants a responsive **web UI pointed at those org files on `lab`** so he can view his
agenda and make simple edits (titles, status, delete, create tasks/notes).

There is **no native NixOS module for organice** — it's a static React PWA distributed as
a Docker image (`twohundredok/organice:latest`, serves on port 5000). It syncs by talking
to a **WebDAV** backend from the browser. So we run organice as a container (matching the
existing `13ft`/`it-tools` pattern) plus a WebDAV server exposing the org tree.

On `lab`, the org files live in **`/zshare/personal/notes/`** (this is the Syncthing
"default" folder, owned `justinhoang:samba`, which maps to `~/orgfiles` on the mac and is
synced to other machines). Decision: WebDAV scoped to that exact directory, **no auth**
(reachable only over the Tailnet). Domain is `sua.dev`.

**Known limitation (acknowledged):** organice's agenda is a single configurable search,
not Justin's custom multi-block nvim dashboard. This gives mobile viewing + full editing
of the real `.org` files, but not a pixel match of the nvim agenda. Approximate via
organice saved searches (e.g. `TODO="INPROGRESS"`, upcoming deadlines).

## Architecture

Single nginx vhost `organice.sua.dev` fronts two loopback services — **same origin means
no CORS configuration is needed** (WebDAV PROPFIND same-origin is not subject to CORS):

```
phone browser ──tailscale──> nginx  organice.sua.dev
                               ├── /      → organice container (127.0.0.1:8089 → :5000)
                               └── /dav   → webdav server      (127.0.0.1:8091)
                                                 │ runs as justinhoang:samba
                                                 ▼
                                       /zshare/personal/notes ──syncthing──> other machines
```

Running the WebDAV server as `justinhoang:samba` (not as `nginx`) means edits are written
as the **file owner**, avoiding permission conflicts with Syncthing. `ORGANICE_WEBDAV_URL`
prefills the sync URL in organice's signin form.

## Changes

Follows the existing per-service directory convention (see
`configurations/nixos/lab/services/it-tools/` — `default.nix` + `compose.nix` + `compose.yml`).

### 1. `lib/infra.nix` — register ports
Add to the `ports = { … }` attrset (8089 and 8091 are currently free; 8090=qbittorrent):
```nix
organice = {
  app = 8089;
  webdav = 8091;
};
```

### 2. `configurations/nixos/lab/services/organice/compose.yml` (new)
```yaml
services:
  organice:
    image: twohundredok/organice:latest
    container_name: organice
    environment:
      - ORGANICE_WEBDAV_URL=https://organice.sua.dev/dav
    ports:
      - "8089:5000"
    restart: unless-stopped
```

### 3. `configurations/nixos/lab/services/organice/compose.nix` (new)
compose2nix output (or hand-written in the identical generated style as
`it-tools/compose.nix`): oci-container `organice`, image pinned by digest/tag, bound to
`127.0.0.1:${toString infra.ports.organice.app}:5000/tcp`, `environment.ORGANICE_WEBDAV_URL`,
own `organice_default` podman network, root target + systemd wiring. Pin a concrete tag/digest
rather than `latest` to match the repo's convention of pinned images.

### 4. `configurations/nixos/lab/services/organice/default.nix` (new)
Mirror `it-tools/default.nix` for the vhost, add the WebDAV service and the `/dav` location:
```nix
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "organice";
in
{
  imports = [ ./compose.nix ];

  # WebDAV backend exposing the org tree; runs as the file owner so edits
  # stay owned by justinhoang:samba and Syncthing propagates them cleanly.
  services.webdav = {
    enable = true;
    user = "justinhoang";
    group = "samba";
    settings = {
      address = "127.0.0.1";
      port = infra.ports.organice.webdav;
      prefix = "/dav";
      directory = "/zshare/personal/notes";
      permissions = "CRUD";   # anonymous read/write (Tailnet-only, no users)
    };
  };
  # group-writable new files so Syncthing (also group samba) can modify them
  systemd.services.webdav.serviceConfig.UMask = "0002";

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];

    locations."/".proxyPass = "http://127.0.0.1:${toString infra.ports.organice.app}";

    locations."/dav" = {
      proxyPass = "http://127.0.0.1:${toString infra.ports.organice.webdav}";
      # recommendedProxySettings (global) forwards Host/methods; Depth header
      # is a normal request header and is passed through. Verify PROPFIND works.
    };
  };
}
```
**Schema caveat to resolve at implementation time:** confirm the `pkgs.webdav` version.
hacdias/webdav **v5** uses `directory` + `permissions` (as above); **v4** used `scope` +
`modify` + `auth`. Match the installed binary's schema.

### 5. `configurations/nixos/lab/services/default.nix` — wire it in
Add `./organice` to the `imports` list (keep alphabetical: between `./navidrome.nix`/`./nginx.nix`).

### 6. make sure that pi's adguardhome config is updated

## Verification

1. Build/deploy to `lab` (`nixos-rebuild switch` via the repo's normal flow for the lab host).
  - also deploy to `pi` for updated DNS record
2. Services up: `systemctl status podman-organice webdav`.
3. WebDAV reachable + scoped correctly (on lab):
   `curl -s -X PROPFIND -H 'Depth: 1' http://127.0.0.1:8091/dav/ | grep -o 'inbox.org'`
   should list the org files.
4. Through nginx (over Tailscale from a laptop):
   `curl -sk -X PROPFIND -H 'Depth: 1' https://organice.sua.dev/dav/` returns the file list
   (no CORS/OPTIONS errors).
5. Browser (phone over Tailscale): open `https://organice.sua.dev`, choose **WebDAV** sync,
   confirm the prefilled URL `https://organice.sua.dev/dav`, open `inbox.org` → verify the
   agenda/todo list renders responsively.
6. **Edit round-trip:** in organice mark a task DONE / add a task; on lab confirm the change
   in `/zshare/personal/notes/inbox.org` and that new/edited files are owned `justinhoang:samba`
   and group-writable; confirm it syncs to another machine and shows up in nvim-orgmode.

## Out of scope / follow-ups
- Replicating the custom nvim 6-block agenda dashboard (organice can't; approximate with saved searches).
- Optional: add a Dashy tile for `organice.sua.dev`.
- Optional: add basic auth later (sops htpasswd) if defense-in-depth beyond Tailscale is wanted.
