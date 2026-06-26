{ pkgs, ... }:

# Optional dev tooling — enabled via features.devTools = true in flake.nix
{
  home.packages = with pkgs; [
    python3   # python3 / pip3
    nvm       # Node version manager (nvm install --lts to install Node)
  ];

  # nvm shell init — loads `nvm` command into your shell
  programs.zsh.initContent = ''
    export NVM_DIR="$HOME/.nvm"
    [ -s "${pkgs.nvm}/nvm.sh" ] && source "${pkgs.nvm}/nvm.sh"
    [ -s "${pkgs.nvm}/bash_completion" ] && source "${pkgs.nvm}/bash_completion"
  '';
}
