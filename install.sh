#!/usr/bin/env bash
set -e

# ── ktt's dotfiles install script ───────────────────────────────────────────
# Installs Nix, nix-darwin, and applies the full configuration.
# Safe to re-run — each step checks before acting.

DOTFILES_DIR="$HOME/.config/dotfiles"
# Read hostname from the system — must match what's in flake.nix
HOSTNAME="$(scutil --get ComputerName)"

echo ""
echo "╭──────────────────────────────────────────╮"
echo "│   ktt dotfiles installer                 │"
echo "╰──────────────────────────────────────────╯"
echo ""

# ── 1. Xcode Command Line Tools ─────────────────────────────────────────────
echo "→ Checking Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  echo "  Installing Xcode CLT..."
  xcode-select --install
  echo "  ⚠  After the installer finishes, re-run this script."
  exit 0
else
  echo "  ✓ Already installed"
fi

# ── 2. Homebrew ──────────────────────────────────────────────────────────────
echo "→ Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  echo "  Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for Apple Silicon
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "  ✓ Already installed"
fi

# ── 3. Nix ──────────────────────────────────────────────────────────────────
echo "→ Checking Nix..."
if ! command -v nix &>/dev/null; then
  echo "  Installing Nix (Determinate Systems installer)..."
  # Determinate Systems installer is more reliable on macOS than the official one
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install
  echo ""
  echo "  ⚠  Nix installed. Please CLOSE and REOPEN your terminal, then re-run this script."
  exit 0
else
  echo "  ✓ Already installed ($(nix --version))"
fi

# ── 4. Clone dotfiles ────────────────────────────────────────────────────────
echo "→ Setting up dotfiles..."
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "  Cloning dotfiles..."
  # Replace this URL with your GitHub repo once you push it
  # git clone https://github.com/ktt/dotfiles.git "$DOTFILES_DIR"
  # For now, copy from current directory:
  mkdir -p "$HOME/.config"
  cp -r "$(dirname "$0")" "$DOTFILES_DIR"
  echo "  ✓ Dotfiles placed at $DOTFILES_DIR"
else
  echo "  ✓ Already at $DOTFILES_DIR"
fi

# ── 5. nix-darwin ────────────────────────────────────────────────────────────
echo "→ Applying nix-darwin configuration..."
echo "  This will take a few minutes on first run (downloading packages)..."
echo ""

cd "$DOTFILES_DIR"

# First-time setup: nix-darwin not yet installed
if ! command -v darwin-rebuild &>/dev/null; then
  echo "  First-time nix-darwin install..."
  nix run nix-darwin -- switch --flake ".#${HOSTNAME}"
else
  darwin-rebuild switch --flake ".#${HOSTNAME}"
fi

echo ""
echo "╭──────────────────────────────────────────╮"
echo "│   ✓  Installation complete!              │"
echo "│                                          │"
echo "│   Open WezTerm and enjoy your setup.     │"
echo "│                                          │"
echo "│   To apply future changes:               │"
echo "│     rebuild    (alias in your zsh)       │"
echo "│   To update all packages:                │"
echo "│     update     (alias in your zsh)       │"
echo "╰──────────────────────────────────────────╯"
echo ""
