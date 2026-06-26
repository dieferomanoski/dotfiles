{ pkgs, lib, username, features, ... }:

# Core is always loaded. Optional modules are gated by feature flags in flake.nix.
{
  imports =
    # ── Core (always loaded — works on macOS, Linux, WSL2) ─────────────────
    [ ./git.nix ./zsh.nix ./starship.nix
      ./optional/wezterm.nix
      ./optional/neovim.nix ]
    # ── Optional (controlled by feature flags in flake.nix) ────────────────
    ++ lib.optional features.devTools ./optional/dev.nix;

  # ── Core CLI packages (small, fast, work everywhere) ─────────────────────
  home.packages = with pkgs; [
    eza        # better ls
    bat        # better cat
    fd         # better find
    ripgrep    # better grep
    fzf        # fuzzy finder
    zoxide     # smarter cd
    jq         # JSON processor
    htop       # process monitor
    delta      # beautiful git diffs
    gh         # GitHub CLI
    nerd-fonts.jetbrains-mono
  ];

  xdg.enable = true;

  home.sessionVariables = {
    EDITOR   = "nvim";
    VISUAL   = "nvim";
    PAGER    = "bat --plain";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  home.username      = username;
  home.homeDirectory = lib.mkForce (
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}"
  );
  home.stateVersion  = "24.05";
  programs.home-manager.enable = true;
}
