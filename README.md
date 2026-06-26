# ktt's dotfiles

A fully reproducible macOS development environment managed by **Nix** + **nix-darwin** + **home-manager**.

Clone this repo on any Mac, run one command, and your entire environment is back — terminal, editor, shell, tools, macOS settings, everything.

---

## What's in here?

```
dotfiles/
├── flake.nix                    ← entry point, declares all dependencies
├── install.sh                   ← one-command installer
├── modules/
│   ├── darwin/
│   │   ├── default.nix          ← system packages + Homebrew casks
│   │   └── settings.nix         ← macOS settings (Dock, Finder, keyboard...)
│   └── home/
│       ├── default.nix          ← user packages (eza, bat, fzf, ripgrep...)
│       ├── wezterm.nix          ← WezTerm (Rosé Pine theme, keybindings)
│       ├── zsh.nix              ← shell (plugins, aliases, fzf config)
│       ├── git.nix              ← git config + delta diff viewer
│       ├── starship.nix         ← prompt (Rosé Pine colors)
│       └── neovim.nix           ← editor (Rosé Pine + plugins)
```

---

## Concepts explained

### What is Nix?
Nix is a package manager (like Homebrew) but **declarative** — instead of running `brew install thing`, you write `thing` in a file and Nix ensures it's installed. The key difference: Nix is reproducible and atomic. You can roll back to any previous state. Two machines with the same config are byte-for-byte identical.

### What is nix-darwin?
nix-darwin is a layer on top of Nix that lets you manage **macOS system settings** in code — your Dock size, Finder preferences, key repeat speed, hostname, Homebrew casks — all declared in `modules/darwin/settings.nix`.

### What is home-manager?
home-manager manages **user-level config files** (dotfiles). Instead of manually creating `~/.gitconfig` or `~/.config/wezterm/wezterm.lua`, home-manager generates and places them automatically from your Nix config.

### What is a flake?
A `flake.nix` is the root file that declares your dependencies (which version of nixpkgs, nix-darwin, home-manager to use) and wires everything together. Think of it like a `package.json` for your entire machine.

### What are dotfiles?
Dotfiles are config files for your tools (named with a dot: `.gitconfig`, `.zshrc`). A dotfiles repo is just all of them in one Git repo. The magic: clone it on a new machine → everything is configured.

---

## Installation (fresh Mac)

```bash
# 1. Clone this repo
git clone https://github.com/dieferomanoski/dotfiles.git ~/.config/dotfiles

# 2. Run the installer
chmod +x ~/.config/dotfiles/install.sh
~/.config/dotfiles/install.sh
```

The script handles: Xcode CLT → Homebrew → Nix → nix-darwin → your full config. It takes ~10 minutes on first run.

---

## Before you run it: edit ONE file

Open `flake.nix` and change the three lines at the top of the `let` block:

```nix
let
  username = "ktt";           # output of: whoami
  hostname = "ktt";           # output of: scutil --get ComputerName
  system   = "aarch64-darwin"; # arm64 → aarch64-darwin  |  x86_64 → x86_64-darwin
```

That's it. The username and hostname flow automatically into every module — nothing else to change.

---

## Daily workflow

| What you want | Command |
|---|---|
| Apply any change you made to a `.nix` file | `rebuild` |
| Update all packages to latest | `update && rebuild` |
| Rollback to previous generation | `darwin-rebuild switch --rollback` |
| See what generations exist | `darwin-rebuild --list-generations` |

---

## What can I customize?

### Change the color theme
Everything uses **Rosé Pine**. To switch:
- **WezTerm**: change `config.color_scheme` in `modules/home/wezterm.nix`
  - Available: `"Catppuccin Mocha"`, `"Tokyo Night"`, `"kanagawa"`, `"nord"`, [300+ more](https://wezfurlong.org/wezterm/colorschemes/)
- **Neovim**: change `variant` in `modules/home/neovim.nix` → `"moon"` or `"dawn"`
- **Starship**: update hex colors in `modules/home/starship.nix`

### Add a GUI app (Homebrew cask)
In `modules/darwin/default.nix`, add to `homebrew.casks`:
```nix
casks = [
  "wezterm"
  "raycast"
  "spotify"    # ← add here
];
```
Then run `rebuild`.

### Add a CLI tool
In `modules/home/default.nix`, add to `home.packages`:
```nix
home.packages = with pkgs; [
  eza
  bat
  tldr      # ← add here (simplified man pages)
];
```
Find packages at [search.nixos.org](https://search.nixos.org/packages). Then run `rebuild`.

### Add a git alias
In `modules/home/git.nix`, add to `aliases`:
```nix
aliases = {
  st   = "status -sb";
  yolo = "push --force";    # ← add here
};
```

### Change your Dock size or macOS settings
Edit `modules/darwin/settings.nix`. Every option has a comment explaining it. Run `rebuild` after.

### Add a zsh alias
In `modules/home/zsh.nix`, add to `shellAliases`:
```nix
shellAliases = {
  ll   = "eza -la --icons";
  yeet = "rm -rf";    # ← add here
};
```

### Add a neovim plugin
In `modules/home/neovim.nix`, add to `plugins`:
```nix
plugins = with pkgs.vimPlugins; [
  rose-pine
  copilot-vim    # ← add here
];
```
Find plugins at [search.nixos.org](https://search.nixos.org/packages?query=vimPlugins).

---

## WezTerm keybindings

Leader key = `CTRL+a` (hold, then press the key below)

| Keys | Action |
|---|---|
| `LEADER + \|` | Split pane right |
| `LEADER + -` | Split pane down |
| `LEADER + h/j/k/l` | Navigate panes (vim-style) |
| `LEADER + H/J/K/L` | Resize pane |
| `LEADER + z` | Zoom pane (fullscreen) |
| `LEADER + x` | Close pane |
| `LEADER + c` | New tab |
| `LEADER + n/p` | Next/previous tab |
| `LEADER + ,` | Rename tab |
| `LEADER + [` | Copy mode (select text with keyboard) |
| `CMD + d` | Split right (macOS-style) |
| `CMD + SHIFT + d` | Split down |
| `CMD + [/]` | Switch tabs |
| `CMD + click` | Open link under cursor |

## Shell shortcuts

| Keys | Action |
|---|---|
| `→` (right arrow) | Accept autosuggestion |
| `CTRL+R` | Fuzzy search command history |
| `CTRL+T` | Fuzzy find file |
| `CTRL+F` | Fuzzy find directory and cd into it |
| `z <name>` | Jump to a frecent directory |
| `z -` | Jump back to previous directory |

## Neovim keybindings

Leader key = `Space`

| Keys | Action |
|---|---|
| `CTRL+P` | Find files |
| `CTRL+F` | Search text in all files |
| `Space + e` | Toggle file tree |
| `Space + fb` | Switch buffer |
| `jk` | Exit insert mode |
| `gcc` | Toggle line comment |
| `gc` (visual) | Toggle comment on selection |
| `cs"'` | Change surrounding `"` to `'` |
| `ds"` | Delete surrounding `"` |
| `CTRL+h/j/k/l` | Navigate splits |

---

## Pushing to GitHub (so you can clone on any machine)

```bash
cd ~/.config/dotfiles
git init
git add .
git commit -m "initial setup"
# Create a repo at github.com, then:
git remote add origin https://github.com/dieferomanoski/dotfiles.git
git push -u origin main
```

Then on any new Mac: `git clone https://github.com/dieferomanoski/dotfiles.git ~/.config/dotfiles && ./install.sh`

---

## Troubleshooting

**`error: hostname does not match`** → Update `"ktt"` in `flake.nix` and `settings.nix` to match your `scutil --get ComputerName` output.

**`error: attribute 'aarch64-darwin' missing`** → You're on Intel. Change `"aarch64-darwin"` to `"x86_64-darwin"` in `flake.nix`.

**WezTerm font shows boxes/missing icons** → Install the Nerd Font: `brew install --cask font-jetbrains-mono-nerd-font`, then restart WezTerm.

**`darwin-rebuild: command not found`** → Close and reopen your terminal after Nix installs.
