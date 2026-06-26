{ ... }:

# Starship — a fast, minimal, highly customizable prompt.
# This config uses Rosé Pine colors to match WezTerm.
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # ── Global ─────────────────────────────────────────────────────────────
      add_newline = true;    # blank line before each prompt
      command_timeout = 500; # ms before a module is skipped (keeps prompt fast)

      format = ''
        $directory$git_branch$git_status$nodejs$python$rust$golang$nix_shell
        $character
      '';

      # ── Directory ──────────────────────────────────────────────────────────
      directory = {
        style            = "bold #9ccfd8";  # foam
        truncation_length = 3;
        truncate_to_repo  = true;
        format           = "[$path]($style)[$read_only]($read_only_style) ";
      };

      # ── Git ────────────────────────────────────────────────────────────────
      git_branch = {
        symbol = " ";  # nerd font branch icon
        style  = "#c4a7e7";    # iris
        format = "on [$symbol$branch]($style) ";
      };

      git_status = {
        style     = "#eb6f92";  # love (red-pink)
        format    = "([$all_status$ahead_behind]($style) )";
        conflicted = "⚡";
        ahead      = "⇡$count";
        behind     = "⇣$count";
        diverged   = "⇕⇡$ahead_count⇣$behind_count";
        untracked  = "?$count";
        modified   = "!$count";
        staged     = "+$count";
        deleted    = "✘$count";
      };

      # ── Prompt character ───────────────────────────────────────────────────
      character = {
        success_symbol = "[❯](#31748f)";  # pine (green) on success
        error_symbol   = "[❯](#eb6f92)";  # love (red) on error
        vimcmd_symbol  = "[❮](#c4a7e7)";  # iris when in vim mode
      };

      # ── Language versions (only shown when in a project) ──────────────────
      nodejs = {
        symbol = " ";
        style  = "#f6c177";  # gold
        format = "via [$symbol($version )]($style)";
      };

      python = {
        symbol = " ";
        style  = "#f6c177";
        format = "via [$symbol($version )($virtualenv )]($style)";
      };

      rust = {
        symbol = " ";
        style  = "#eb6f92";
        format = "via [$symbol($version )]($style)";
      };

      golang = {
        symbol = " ";
        style  = "#9ccfd8";
        format = "via [$symbol($version )]($style)";
      };

      nix_shell = {
        symbol = " ";
        style  = "#9ccfd8";
        format = "via [$symbol$state]($style) ";
      };
    };
  };
}
