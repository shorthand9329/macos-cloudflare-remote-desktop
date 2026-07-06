# Cloudflare Access policy notes

Use Cloudflare Access to restrict who can reach the remote desktop hostname.

Recommended baseline:

- Application type: Self-hosted / private application.
- Hostname: your VNC hostname, for example `vnc.example.com`.
- Session duration: short enough for your risk profile.
- Policy action: Allow.
- Include: your exact email address or a small IdP group.
- Require: MFA, if available.
- Avoid: Bypass policies for the VNC hostname.

For browser-based VNC, enable Cloudflare's browser-rendered VNC option in the Access application. For native VNC clients, use `cloudflared access tcp` locally and connect the VNC client to the local port.
