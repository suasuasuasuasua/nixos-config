#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() { echo "==> $*"; }

cd "$REPO_DIR"

log "Switching lab (local)..."
just switch

log "Deploying pi..."
just deploy pi admin@pi.ts.sua.dev || true

log "Deploying hetzner-cloud-vps0..."
just deploy hetzner-cloud-vps0 admin@hetzner-cloud-vps0.ts.sua.dev

log "Deploying hp-optiplex0..."
just deploy hp-optiplex0 admin@hp-optiplex0.ts.sua.dev

log "All deployments complete."
