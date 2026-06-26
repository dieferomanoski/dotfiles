{ pkgs, hostname, lib, ... }:

{
  programs.zsh = {
    enable = true;

    # ── History ──────────────────────────────────────────────────────────────
    history = {
      size     = 50000;
      save     = 50000;
      share    = true;     # share history across all open terminals
      ignoreDups = true;
    };

    # ── Plugins ──────────────────────────────────────────────────────────────
    autosuggestion.enable  = true;   # grey ghost text as you type (→ to accept)
    syntaxHighlighting.enable = true; # colors commands as you type (red = invalid)
    enableCompletion       = true;

    # ── Oh-My-Zsh ─────────────────────────────────────────────────────────
    oh-my-zsh = {
      enable  = true;
      plugins = [
        "git"          # git aliases: gst, gco, gcb, gp, gl…
        "macos"        # macOS helpers: ofd (open finder here), quick-look
        "fzf"          # CTRL+R fuzzy history, CTRL+T fuzzy file
        "z"            # jump to frecent dirs: z proj → ~/code/myproject
        "copypath"     # copies current path to clipboard
        "copyfile"     # copies file content to clipboard
      ];
      # No theme — we use Starship instead (configured in starship.nix)
      theme = "";
    };

    # ── Aliases ──────────────────────────────────────────────────────────────
    shellAliases = {
      # Better defaults
      ls    = "eza --icons --group-directories-first";
      ll    = "eza --icons --group-directories-first -la";
      lt    = "eza --icons --tree --level=2";
      cat   = "bat";
      grep  = "rg";
      find  = "fd";
      cd    = "z";          # use zoxide instead of plain cd

      # Git shortcuts (on top of oh-my-zsh git plugin)
      g     = "git";
      ga    = "git add";
      gaa   = "git add --all";
      gc    = "git commit";
      gcm   = "git commit -m";
      gca   = "git commit --amend";
      gp    = "git push";
      gpf   = "git push --force-with-lease";
      gl    = "git pull";
      gd    = "git diff";
      gds   = "git diff --staged";
      glog  = "git log --oneline --graph --decorate";

      # Nix / dotfiles — hostname baked in at build time from flake.nix
      rebuild = "darwin-rebuild switch --flake ~/.config/dotfiles#${hostname}";
      update  = "nix flake update ~/.config/dotfiles";

      # Navigation
      ".."  = "cd ..";
      "..." = "cd ../..";
      "~"   = "cd ~";
    };

    # ── Extra init (runs at shell startup) ────────────────────────────────
    initContent = ''
      # nvm — Node version manager
      export NVM_DIR="$HOME/.nvm"
      [ -s "${pkgs.nvm}/nvm.sh" ] && source "${pkgs.nvm}/nvm.sh"
      [ -s "${pkgs.nvm}/bash_completion" ] && source "${pkgs.nvm}/bash_completion"

      # zoxide init (smarter cd)
      eval "$(zoxide init zsh)"

      # fzf config
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=bg+:#26233a,bg:#191724,spinner:#f6c177,hl:#31748f,fg:#e0def4,header:#31748f,info:#9ccfd8,pointer:#eb6f92,marker:#eb6f92,fg+:#e0def4,prompt:#9ccfd8,hl+:#eb6f92"

      # Shell integration for WezTerm (semantic zones, prompt tracking)
      if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
        source "$(wezterm shell-integration zsh 2>/dev/null)" 2>/dev/null || true
      fi

      # CTRL+F → launch fzf to cd into a directory
      bindkey -s '^f' 'cd "$(fd --type d --hidden --exclude .git | fzf)"\n'
    '';
  };
}
