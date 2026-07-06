#!/usr/bin/env bash
set -euo pipefail

hostname="${1:-}"
local_port="${2:-5901}"

if [[ -z "$hostname" ]]; then
  echo "Usage: $0 <access-hostname> [local-port]" >&2
  echo "Example: $0 vnc.example.com 5901" >&2
  exit 1
fi

if ! command -v cloudflared >/dev/null 2>&1; then
  echo "cloudflared is required on the client machine." >&2
  exit 1
fi

echo "Starting Cloudflare Access TCP proxy for $hostname on localhost:$local_port"
echo "Open your VNC client and connect to localhost:$local_port"

cloudflared access tcp --hostname "$hostname" --url "localhost:$local_port"
