{ pkgs, ... }:

{
  # ── Nix daemon ──────────────────────────────────────────────────────────────
  # Determinate Systems manages its own Nix daemon — disable nix-darwin's.
  # flakes + nix-command are already enabled by Determinate.
  nix.enable = false;

  # ── macOS system defaults ────────────────────────────────────────────────────
  system.defaults = {
    dock = {
      autohide                  = true;
      autohide-delay            = 0.03;
      autohide-time-modifier    = 0.03;
      magnification             = true;
      tilesize                  = 35;
      largesize                 = 42;
      mineffect                 = "scale";
      minimize-to-application   = true;
      orientation               = "left";
      show-recents              = false;
    };

    finder = {
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "Nlsv";
      NewWindowTarget = "Home";
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      KeyRepeat        = 1;
      InitialKeyRepeat = 8;
      NSAutomaticSpellingCorrectionEnabled = true;
      NSAutomaticCapitalizationEnabled     = true;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled   = true;
      NSAutomaticPeriodSubstitutionEnabled = true;
      AppleShowScrollBars        = "Always";
      NSNavPanelExpandedStateForSaveMode  = true;
      PMPrintingExpandedStateForPrint     = true;
      "com.apple.trackpad.scaling" = 3.0;
      "com.apple.swipescrolldirection" = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      TrackpadRightClick      = true;
    };

    screensaver.askForPasswordDelay = 0;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = false; # managed by Hyperkey
  };

  # ── Homebrew ─────────────────────────────────────────────────────────────────
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    casks = [
      "aldente"
      "bitwarden"   # direct download — required for SSH agent (App Store version is sandboxed)
      "hyperkey"
      "bruno"
      "claude-code"
      "dropbox"
      "fluor"
      "freecad"
      "ghostty"
      "google-chrome"
      "google-drive"
      "gpg-suite"
      "linear-linear"
      "messenger"
      "notion"
      "obsidian"
      "raycast"
      "remarkable"
      "slack"
      "zed"
    ];

    brews = [
      "mas"
    ];

    masApps = {
      "No Distractions for YouTube" = 1482507016;
      "NextDNS"                     = 1464122853;
      "OneDrive"                    = 823766827;
      "Tailscale"                   = 1475387142;
      "WireGuard"                   = 1451685025;
      "Xcode"                       = 497799835;
      "Magnet"                      = 441258766;
      "Wipr 2"                      = 1662217862;
      "Xerox Print and Scan"        = 6443456959;
    };
  };

  system.primaryUser = "froeb";

  # ── Users ────────────────────────────────────────────────────────────────────
  users.users.froeb = {
    name = "froeb";
    home = "/Users/froeb";
  };

  # ── System state version ─────────────────────────────────────────────────────
  # Do not change after initial install.
  system.stateVersion = 5;
}
