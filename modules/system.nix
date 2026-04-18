_:

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
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      TrackpadRightClick = true;
    };

    screensaver.askForPasswordDelay = 0;

    CustomUserPreferences = {
      "com.apple.AppleMultitouchTrackpad" = {
        TrackpadThreeFingerVertSwipeGesture = 2; # App Exposé with 3 fingers
        TrackpadFourFingerVertSwipeGesture = 0;
      };
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = false; # managed by Hyperkey
  };

  system.primaryUser = "froeb";

  # ── Users ────────────────────────────────────────────────────────────────────────
  users.users.froeb = {
    name = "froeb";
    home = "/Users/froeb";
  };

  # ── System state version ─────────────────────────────────────────────────────
  # Do not change after initial install.
  system.stateVersion = 5;
}
