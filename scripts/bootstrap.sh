#!/usr/bin/env bash
# bootstrap.sh: set up a brand-new Mac up through the first nix-darwin
# activation. Idempotent — safe to re-run after a partial failure.
#
# Usage (blank machine, nothing cloned yet):
#   curl -fsSL https://raw.githubusercontent.com/jofrb/nix-config/main/scripts/bootstrap.sh | bash
#
# Usage (repo already cloned):
#   ~/.config/nix-config/scripts/bootstrap.sh
#
# What this does NOT do (left manual — needs interactive secrets):
#   - SSH key generation / registration
#   - Bitwarden login (needed for the SSH agent used by programs.ssh)
#   - `gh auth login`
#   - Signing into other apps (Slack, etc.)

set -euo pipefail

REPO_URL="https://github.com/jofrb/nix-config.git"
REPO_DIR="$HOME/.config/nix-config"
PROFILE_FILE="$HOME/.config/nix-darwin-profile"

log() { printf '\n==> %s\n' "$1"; }

# ── 1. Make sure we're running from a clone of the repo ──────────────────────
if [[ "${BASH_SOURCE[0]:-}" != "$REPO_DIR/scripts/bootstrap.sh" ]]; then
  log "Checking for git (via Xcode Command Line Tools)..."
  if ! command -v git >/dev/null 2>&1; then
    echo "git not found — triggering Xcode Command Line Tools install."
    xcode-select --install
    echo "Finish that install, then re-run this script."
    exit 1
  fi

  if [[ ! -d "$REPO_DIR/.git" ]]; then
    log "Cloning $REPO_URL to $REPO_DIR..."
    mkdir -p "$(dirname "$REPO_DIR")"
    git clone "$REPO_URL" "$REPO_DIR"
  fi

  log "Re-running bootstrap from the cloned repo..."
  exec "$REPO_DIR/scripts/bootstrap.sh"
fi

# ── 2. Determinate Nix ────────────────────────────────────────────────────────
if ! command -v nix >/dev/null 2>&1; then
  log "Installing Determinate Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
fi
export PATH="/nix/var/nix/profiles/default/bin:$PATH"

# ── 3. Homebrew ────────────────────────────────────────────────────────────────
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# ── 4. Profile selection ──────────────────────────────────────────────────────
if [[ -f "$PROFILE_FILE" ]]; then
  PROFILE="$(cat "$PROFILE_FILE")"
else
  echo
  echo "Which profile should this machine use?"
  echo "  1) base"
  echo "  2) Netlight"
  read -rp "> " choice </dev/tty
  case "$choice" in
    1) PROFILE="base" ;;
    2) PROFILE="Netlight" ;;
    *) echo "Unrecognized choice: $choice"; exit 1 ;;
  esac
  mkdir -p "$(dirname "$PROFILE_FILE")"
  echo "$PROFILE" > "$PROFILE_FILE"
fi
log "Using profile: $PROFILE"

# ── 5. First nix-darwin activation ────────────────────────────────────────────
# `darwin-rebuild switch`'s nested per-user home-manager activation silently
# no-ops on this macOS version (see nrs alias comment in modules/home.nix).
# Build then activate directly instead.
log "Building darwinConfigurations.$PROFILE..."
OUT=$(nix build --no-link --print-out-paths --refresh "$REPO_DIR#darwinConfigurations.$PROFILE.system")
log "Activating..."
sudo "$OUT/activate"

log "Done."
cat <<EOF

Remaining manual steps:
  - Restart your terminal (zsh, tmux, starship are now active).
  - Install Bitwarden Desktop and enable Settings → SSH Agent.
  - Run: gh auth login
  - Sign into other apps (Slack, Dropbox, etc.) as needed.
EOF

# ── 6. Offer a restart ────────────────────────────────────────────────────────
# Key repeat, trackpad speed and dark mode only take full effect after a
# restart. Read from /dev/tty so this works under `curl | bash` too.
if [[ -r /dev/tty ]]; then
  read -rp $'\nRestart now to apply all system settings? [y/N] ' answer </dev/tty || answer=""
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    sudo shutdown -r now
  fi
fi
