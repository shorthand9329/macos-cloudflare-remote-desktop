#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script must be run on macOS." >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required to install cloudflared." >&2
  echo "Install Homebrew from https://brew.sh, then rerun this script." >&2
  exit 1
fi

if ! command -v cloudflared >/dev/null 2>&1; then
  brew install cloudflared
fi

cloudflared --version

if lsof -nP -iTCP:5900 -sTCP:LISTEN >/dev/null 2>&1; then
  echo "VNC/Screen Sharing appears to be listening on localhost port 5900."
else
  echo "No listener found on TCP port 5900. Enable macOS Screen Sharing or Remote Management before starting the tunnel." >&2
fi

cat <<'NEXT_STEPS'

Next steps:
1. Create a Cloudflare Tunnel in Zero Trust > Networks > Tunnels.
2. Add a public hostname that targets tcp://localhost:5900 or service TCP localhost:5900.
3. Protect the hostname with a Cloudflare Access policy.
4. Run: cloudflared tunnel run --token "$CLOUDFLARED_TUNNEL_TOKEN"

NEXT_STEPS
