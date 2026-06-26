{ pkgs, username, hostname, ... }:

{
  imports = [ ./settings.nix ];

  # ── System packages ────────────────────────────────────────────────────────
  # These are installed system-wide (available to all users).
  # For user-specific tools, use modules/home/default.nix instead.
  environment.systemPackages = with pkgs; [
    git        # version control (system-level so it's always available)
    curl
    wget
    unzip
  ];

  # ── Homebrew (optional) ────────────────────────────────────────────────────
  # Nix manages CLI tools; Homebrew manages GUI apps (casks).
  # This lets nix-darwin declare which brew casks to install.
  # Requires Homebrew to be installed first (install.sh handles this).
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup    = "none";   # don't touch apps not in the list
      upgrade    = true;
    };
    # GUI apps — add/remove as you like
    casks = [
      "wezterm"              # our terminal — managed here so it's always installed
      # Add GUI apps here to have Nix track them. Already-installed apps are fine to add.
      # "raycast"
      # "arc"
      # "visual-studio-code"
      # "spotify"
      # "notion"
    ];
    # CLI tools available via brew (prefer nix packages when possible)
    brews = [];
    # Mac App Store apps (requires `mas` — uncomment to enable)
    # masApps = {
    #   "Xcode" = 497799835;
    # };
  };

  # ── Nix settings ───────────────────────────────────────────────────────────
  # Determinate Nix manages its own daemon — nix-darwin must not conflict with it
  nix.enable = false;

  # ── Shell ─────────────────────────────────────────────────────────────────
  programs.zsh.enable = true;   # zsh must be enabled at system level too

  # ── Required by nix-darwin ────────────────────────────────────────────────
  system.stateVersion = 5;
}
