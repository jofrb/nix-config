{ lib, ... }:

{
  # ── Nix daemon ──────────────────────────────────────────────
  # Determinate Systems manages its own Nix daemon — disable nix-darwin's.
  # flakes + nix-command are already enabled by Determinate.
  nix.enable = false;

  # ── macOS system defaults ────────────────────────────────────────────
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.03;
      autohide-time-modifier = 0.03;
      magnification = true;
      tilesize = 35;
      largesize = 42;
      mineffect = "scale";
      minimize-to-application = true;
      orientation = "left";
      show-recents = false;
      showAppExposeGestureEnabled = true;
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
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
      NSAutomaticSpellingCorrectionEnabled = true;
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = true;
      AppleShowScrollBars = "Always";
      NSNavPanelExpandedStateForSaveMode = true;
      PMPrintingExpandedStateForPrint = true;
      "com.apple.trackpad.scaling" = 3.0;
      "com.apple.swipescrolldirection" = true;
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay" = 0.1;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = false; # managed by Hyperkey
  };

  system.primaryUser = "froeb";

  # ── TouchID for sudo ─────────────────────────────────────────────────────────────
  # reattach fixes TouchID inside tmux (pam_reattach)
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  # ── Users ────────────────────────────────────────────────────────────────────────
  users.users.froeb = {
    name = "froeb";
    home = "/Users/froeb";
  };

  # ── Display sleep ────────────────────────────────────────────────────────────
  # nix-darwin has no native option for displaysleep — use pmset directly.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    pmset -b displaysleep 2
    pmset -c displaysleep 2

    # ── SmartCard / YubiKey PIV policy ───────────────────────────────────────
    # Allow YubiKey PIV as a login factor without enforcing it.
    # Password remains a fallback; enforceSmartCard must stay false.
    defaults write /Library/Preferences/com.apple.security.smartcard allowSmartCard -bool true
    defaults write /Library/Preferences/com.apple.security.smartcard enforceSmartCard -bool false
    defaults write /Library/Preferences/com.apple.security.smartcard userPairing -bool true
  '';

  # ── System state version ─────────────────────────────────────────────────────
  # Do not change after initial install.
  system.stateVersion = 5;
}
