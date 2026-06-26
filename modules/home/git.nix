{ ... }:

{
  programs.git = {
    enable = true;

    # home-manager now uses `settings` for everything (userName/userEmail/aliases/extraConfig all removed)
    settings = {

      # ── Identity ───────────────────────────────────────────────────────────
      user = {
        name  = "dieferomanoski";
        # email is set locally in ~/.gitconfig.local (not committed — keep it private)
        # Run once: git config --global user.email "your@email.com"
      };

      # ── Core settings ──────────────────────────────────────────────────────
      init.defaultBranch   = "main";
      pull.rebase          = true;
      push.autoSetupRemote = true;
      fetch.prune          = true;

      core = {
        autocrlf = "input";
        editor   = "nvim";
        pager    = "delta";
      };

      merge.conflictstyle    = "diff3";
      interactive.diffFilter = "delta --color-only";

      # ── Delta diff viewer ──────────────────────────────────────────────────
      delta = {
        navigate     = true;
        light        = false;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "base16";
      };

      # ── URL shortcut: `git clone gh:user/repo` ─────────────────────────────
      "url \"git@github.com:\"" = {
        insteadOf = "gh:";
      };

      # ── Aliases ────────────────────────────────────────────────────────────
      alias = {
        st      = "status -sb";
        lg      = "log --oneline --graph --decorate --all";
        undo    = "reset --soft HEAD~1";
        wip     = "commit -am 'wip'";
        aliases = "config --get-regexp alias";
      };
    };

    # ── .gitignore (global) ──────────────────────────────────────────────────
    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Thumbs.db"
      "*.swp"
      "*.swo"
      ".env"
      ".env.local"
      "node_modules/"
      ".direnv/"
      ".devenv/"
    ];
  };
}
