# dotfiles

A reproducible development environment managed by **Nix** + **nix-darwin** + **home-manager**.

Clone on any Mac or Linux machine, run one command, and your entire environment is back — terminal, editor, shell, tools, macOS settings, everything.

---

## What's in here?

```
dotfiles/
├── flake.nix                         ← entry point — edit 3 lines for your machine
├── install.sh                        ← one-command bootstrap
└── modules/
    ├── darwin/
    │   ├── default.nix               ← macOS: Homebrew casks + system packages
    │   └── settings.nix              ← macOS: Dock, Finder, keyboard, trackpad
    └── home/
        ├── default.nix               ← core packages + feature flag routing
        ├── git.nix                   ← git config + delta diffs
        ├── zsh.nix                   ← shell config, aliases, plugins
        ├── starship.nix              ← prompt (Rosé Pine)
        └── optional/
            ├── wezterm.nix           ← terminal (Rosé Pine, LEADER keybindings)
            ├── neovim.nix            ← editor (Rosé Pine + plugins)
            └── dev.nix               ← nvm, python3
```

---

## Platform support

| Platform | How |
|---|---|
| macOS | `nix-darwin` + `home-manager` — full setup |
| Linux | standalone `home-manager` — all home modules, no darwin modules |
| Windows | use WSL2 → same as Linux |

---

## Setup (fresh machine)

### macOS

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.config/dotfiles
chmod +x ~/.config/dotfiles/install.sh
~/.config/dotfiles/install.sh
```

### Linux

```bash
# 1. Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
# 2. Clone
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.config/dotfiles
# 3. Apply
nix run home-manager -- switch --flake ~/.config/dotfiles#YOUR_USERNAME
```

---

## Before you run it: edit ONE file

Open `flake.nix` and set these three lines at the top of the `let` block:

```nix
let
  username = "your-username";   # run: whoami
  hostname = "your-hostname";   # run: scutil --get ComputerName (mac) | hostname (linux)
  system   = "aarch64-darwin";  # aarch64-darwin | x86_64-darwin | x86_64-linux | aarch64-linux
```

Then set your git identity (not stored in the repo):

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
```

---

## Optional modules

In `flake.nix`, the `features` block controls optional modules:

```nix
features = {
  devTools = true;   # nvm, python3 — set false on servers / minimal installs
};
```

For optional **GUI apps** (macOS only), uncomment what you want in `modules/darwin/default.nix`:

```nix
casks = [
  "wezterm"
  # "spotify"
  # "arc"
  # "raycast"
  # "notion"
  # "slack"
];
```

---

## Daily workflow

| What you want | Command |
|---|---|
| Apply a config change | `rebuild` |
| Update all packages | `update && rebuild` |
| Roll back to previous | `darwin-rebuild switch --rollback` |

---

## Customization

**Add a GUI app (macOS Homebrew)** — edit `modules/darwin/default.nix`:
```nix
casks = [ "wezterm" "spotify" ];
```

**Add a CLI tool** — edit `modules/home/default.nix`:
```nix
home.packages = with pkgs; [ eza bat tldr ];
```

**Add a zsh alias** — edit `modules/home/zsh.nix`:
```nix
shellAliases = { yeet = "rm -rf"; };
```

**Toggle an optional module** — edit `features` in `flake.nix`.

---

## WezTerm keybindings

Leader = `CTRL+a`

| Keys | Action |
|---|---|
| `LEADER + \|` | Split right |
| `LEADER + -` | Split down |
| `LEADER + h/j/k/l` | Navigate panes |
| `LEADER + z` | Zoom pane |
| `LEADER + x` | Close pane |
| `LEADER + c` | New tab |
| `LEADER + n/p` | Next/previous tab |
| `CMD + d` | Split right |
| `CMD + [/]` | Switch tabs |

## Shell shortcuts

| Keys | Action |
|---|---|
| `→` | Accept suggestion |
| `CTRL+R` | Fuzzy history search |
| `CTRL+T` | Fuzzy file search |
| `CTRL+F` | Fuzzy cd |
| `z name` | Jump to frecent dir |

## Neovim (Space as leader)

| Keys | Action |
|---|---|
| `CTRL+P` | Find files |
| `CTRL+F` | Search in files |
| `Space+e` | File tree |
| `jk` | Exit insert mode |
| `gcc` | Toggle comment |

---

## Troubleshooting

**`error: hostname does not match`** → set `hostname` in `flake.nix` to match `scutil --get ComputerName`.

**`error: attribute missing`** → wrong `system` value in `flake.nix`. Run `uname -m` to check: `arm64` = `aarch64`, `x86_64` = `x86_64`.

**WezTerm shows boxes instead of icons** → run `brew install --cask font-jetbrains-mono-nerd-font`, restart WezTerm.

**`darwin-rebuild: command not found`** → close and reopen terminal after Nix installs.
