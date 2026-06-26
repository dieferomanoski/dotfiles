{ username, hostname, ... }:

# macOS system settings — all configurable in code.
# After changing anything here, run: rebuild
{
  system.defaults = {

    # ── Dock ────────────────────────────────────────────────────────────────
    dock = {
      autohide                = true;    # hide dock when not in use
      autohide-delay          = 0.0;     # no delay before showing
      autohide-time-modifier  = 0.2;     # animation speed (seconds)
      tilesize                = 48;      # icon size in pixels
      show-recents            = false;   # hide recent apps
      minimize-to-application = true;    # minimize into the app icon
      launchanim              = false;   # no launch animation
      orientation             = "bottom";
      # Persistent apps in the Dock — comment out to leave Dock unmanaged
      # persistent-apps = [
      #   "/Applications/Arc.app"
      #   "/Applications/WezTerm.app"
      # ];
    };

    # ── Finder ──────────────────────────────────────────────────────────────
    finder = {
      AppleShowAllFiles              = true;   # show hidden files
      ShowPathbar                    = true;   # show path bar at bottom
      ShowStatusBar                  = true;   # show status bar
      FXDefaultSearchScope           = "SCcf"; # search current folder by default
      FXEnableExtensionChangeWarning = false;  # no warning when changing extension
      _FXShowPosixPathInTitle        = true;   # show full path in title bar
      FXPreferredViewStyle           = "Nlsv"; # list view
    };

    # ── Keyboard & input ────────────────────────────────────────────────────
    NSGlobalDomain = {
      KeyRepeat                            = 2;     # key repeat rate (lower = faster, min 1)
      InitialKeyRepeat                     = 15;    # delay before repeat starts
      ApplePressAndHoldEnabled             = false; # disable hold-for-accent, enable repeat
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled     = false;
      NSAutomaticDashSubstitutionEnabled   = false;
      NSAutomaticQuoteSubstitutionEnabled  = false;
      AppleInterfaceStyle                  = "Dark";
    };

    # ── Screenshots ─────────────────────────────────────────────────────────
    screencapture = {
      location       = "~/Desktop";
      type           = "png";
      disable-shadow = true;
    };

    # ── Trackpad ────────────────────────────────────────────────────────────
    trackpad = {
      Clicking           = true;  # tap to click
      TrackpadRightClick = true;  # two-finger right click
    };
  };

  # ── Hostname — sourced from flake.nix, no hardcoding here ───────────────────
  networking.hostName     = hostname;
  networking.computerName = hostname;

  # ── Primary user — required by nix-darwin for user-level settings ────────────
  system.primaryUser = username;
}
