# nix-config

My macOS system configuration — reproducible, declarative, version-controlled.
Built with [nix-darwin](https://github.com/LnL7/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager), on [Determinate Nix](https://determinate.systems/).

## New machine

Prerequisites:
- Apple Silicon Mac (flake targets `aarch64-darwin` only)
- Admin/sudo password for the account (needed for the Nix install and the
  final activation step)
- Internet connection

```
curl -fsSL https://raw.githubusercontent.com/jofrb/nix-config/main/scripts/bootstrap.sh | bash
```

This installs Xcode Command Line Tools (if needed), Determinate Nix, Homebrew,
clones this repo to `~/.config/nix-config`, and activates the chosen profile
(`base` or `Netlight`). If Xcode CLT/git aren't installed yet, the script
triggers that install and asks you to re-run once it finishes (needs a GUI
click, so it can't be fully unattended on a brand-new machine). Otherwise
safe to re-run if interrupted partway through.

Left manual afterwards, since they need interactive secrets:
- Bitwarden Desktop login + enabling Settings → SSH Agent
- `gh auth login`
- Signing into other apps (Slack, Dropbox, etc.)

## Day-to-day

- `nrs` — rebuild and activate the current profile
- `nfmt` — format the flake
- `nlint` — lint (statix + deadnix)

## Profiles

- `base` — personal config, used by default
- `Netlight` — extends `base` with work-specific additions (see `modules/netlight.nix`)

Which profile a machine uses is recorded in `~/.config/nix-darwin-profile`,
written on first bootstrap.
