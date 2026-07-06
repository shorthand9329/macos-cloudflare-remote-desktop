# macOS Cloudflare Remote Desktop

This repository provides a safe scaffold for exposing **your own macOS host** through Cloudflare Tunnel for remote desktop access.

It intentionally does not start remote desktop on GitHub-hosted runners, does not change account passwords, and does not publish secrets into repository files.

## Architecture

```text
VNC client or browser
        |
Cloudflare Access policy
        |
Cloudflare Tunnel public hostname
        |
cloudflared running on your Mac
        |
macOS Screen Sharing / VNC on localhost:5900
```

## Prerequisites

- A Mac you own or are authorized to administer.
- macOS Screen Sharing enabled on that Mac.
- A Cloudflare Zero Trust account.
- A domain added to Cloudflare if you want a public hostname such as `vnc.example.com`.
- A Cloudflare API token with permissions to manage Cloudflare Tunnel and Access if you want to automate setup.

At the time this scaffold was created, the connected Cloudflare account did not have any zones, and the available API token could not create Cloudflare Tunnels. Add a domain to Cloudflare and use a token with Tunnel management permissions before running the optional API setup.

## Server setup on macOS

Run this on the Mac that will be accessed remotely:

```bash
./scripts/install-macos-host.sh
```

The script installs `cloudflared` with Homebrew if needed and checks whether something is listening on VNC port `5900`. It does not enable Screen Sharing for you because that is an administrative security decision.

To enable Screen Sharing manually:

1. Open **System Settings**.
2. Go to **General > Sharing**.
3. Enable **Screen Sharing** or **Remote Management**.
4. Restrict access to specific local users.
5. Use a strong macOS account password.

## Cloudflare Tunnel setup

Preferred dashboard path:

1. Cloudflare dashboard: **Zero Trust > Networks > Tunnels**.
2. Create a tunnel named `macos-remote-desktop`.
3. Install and run the connector on your Mac using the token shown by Cloudflare.
4. Add a public hostname, for example `vnc.example.com`.
5. Set service type to `TCP` and target to `localhost:5900`.
6. Create a Cloudflare Access application for the hostname.
7. Allow only your email or identity provider group.
8. If using browser-based VNC, enable browser rendering for VNC in the Access app.

You can use `cloudflare/tunnel-ingress.example.yml` as a reference for a locally managed tunnel.

## Run cloudflared with a token

After Cloudflare gives you a connector token, run this on the Mac:

```bash
cloudflared tunnel run --token "$CLOUDFLARED_TUNNEL_TOKEN"
```

For a persistent service:

```bash
sudo cloudflared service install "$CLOUDFLARED_TUNNEL_TOKEN"
```

Never commit the token. Store it in a local password manager, macOS Keychain, or GitHub Actions secret only if a workflow truly needs it.

## Client connection

For a native VNC client through Cloudflare Access:

```bash
./scripts/connect-vnc-client.sh vnc.example.com 5901
```

Then connect your VNC client to:

```text
localhost:5901
```

For browser-based VNC, open the Access application hostname in your browser after configuring the Access app with VNC browser rendering.

## Security notes

- Do not expose VNC without Cloudflare Access or equivalent authentication.
- Do not allow broad email domains unless that is intentional.
- Do not reuse local account passwords.
- Prefer device posture and MFA policies in Cloudflare Access.
- Keep Screen Sharing disabled when you do not need it.
- Rotate the Cloudflare tunnel connector token if it is exposed.

## What this is not

This is not a GitHub Actions workflow that turns GitHub-hosted macOS runners into remote desktops. That pattern can violate platform terms and creates unauthorized access risk. This repository is for remote access to Mac hardware you control.
