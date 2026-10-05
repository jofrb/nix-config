_:

{
  # ── Homebrew ─────────────────────────────────────────────────────────────────
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    casks = [
      "bitwarden" # direct download — required for SSH agent (App Store version is sandboxed)
      "hyperkey"
      "bruno"
      "claude-code"
      "dropbox"
      "fluor"
      "ghostty"
      "google-chrome"
      "google-drive"
      "gpg-suite"
      "whatsapp"
      "obsidian"
      "raycast"
      "slack"
      "zed"
      "chatgpt"
      "yubico-authenticator"
      "tor-browser"
    ];

    brews = [
      "mas"
      "podman"
      "ykman"
    ];

    masApps = {
      "No Distractions for YouTube" = 1482507016;
      "NextDNS" = 1464122853;
      "OneDrive" = 823766827;
      "Tailscale" = 1475387142;
      "WireGuard" = 1451685025;
      "Xcode" = 497799835;
      "Magnet" = 441258766;
      "Wipr 2" = 1662217862;
      "Xerox Print and Scan" = 6443456959;
      "Be Focused - Pomodoro Timer" = 973134470;
    };
  };
}
