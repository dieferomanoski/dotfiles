{ pkgs, lib, username, ... }:

{
  imports = [
    ./wezterm.nix
    ./zsh.nix
    ./git.nix
    ./starship.nix
    ./neovim.nix
  ];

  # ── User-level packages ────────────────────────────────────────────────────
  # CLI tools installed for your user only.
  # Find packages at: https://search.nixos.org/packages
  home.packages = with pkgs; [
    # Shell utilities
    eza          # modern `ls` replacement (shows icons, colors, tree)
    bat          # modern `cat` with syntax highlighting
    fd           # fast `find` replacement
    ripgrep      # fast `grep` replacement (used by neovim too)
    fzf          # fuzzy finder — CTRL+R for history, CTRL+T for files
    zoxide       # smarter `cd` — jump to frecent directories with `z`
    jq           # JSON processor
    htop         # process monitor

    # Git extras
    delta        # beautiful git diffs (configured in git.nix)
    gh           # GitHub CLI — create PRs, issues from terminal

    # Fonts (Nerd Font for icons in WezTerm / Starship)
    # nixpkgs-unstable split nerdfonts into individual packages under nerd-fonts.*
    nerd-fonts.jetbrains-mono

    # Python
    python3          # latest Python 3 (python3 / pip3 in your shell)

    # Node version manager — installs/switches Node versions with `nvm install`
    nvm
  ];

  # ── XDG base directories ───────────────────────────────────────────────────
  xdg.enable = true;

  # ── Session variables ──────────────────────────────────────────────────────
  home.sessionVariables = {
    EDITOR  = "nvim";
    VISUAL  = "nvim";
    PAGER   = "bat --plain";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";  # man pages with color
  };

  # ── home-manager required settings ────────────────────────────────────────
  # username flows in from flake.nix — never hardcoded here
  home.username      = username;
  home.homeDirectory = lib.mkForce (
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}"
  );
  home.stateVersion  = "24.05";
  programs.home-manager.enable = true;
}
