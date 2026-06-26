{
  description = "dotfiles — nix-darwin (macOS) + home-manager (macOS/Linux)";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin       = { url = "github:LnL7/nix-darwin"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager     = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    # ── Edit these three lines when setting up on a new machine ─────────────
    username = "your-username";   # run: whoami
    hostname = "your-hostname";   # run: scutil --get ComputerName (mac) | hostname (linux)
    system   = "aarch64-darwin";  # aarch64-darwin | x86_64-darwin | x86_64-linux | aarch64-linux
    # ────────────────────────────────────────────────────────────────────────

    # ── Feature flags — set false to skip on specific machines ─────────────
    features = {
      devTools = true;   # nvm, python3 — set false on servers / minimal installs
    };
    # ────────────────────────────────────────────────────────────────────────

    sharedArgs = { inherit username hostname features; };
    isLinux    = nixpkgs.lib.hasSuffix "-linux" system;
    isDarwin   = nixpkgs.lib.hasSuffix "-darwin" system;

  in {

    # ── macOS ────────────────────────────────────────────────────────────────
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./modules/darwin
        { _module.args = sharedArgs; }
        home-manager.darwinModules.home-manager
        {
          system.primaryUser               = username;
          home-manager.useGlobalPkgs       = true;
          home-manager.useUserPackages     = true;
          home-manager.users.${username}   = import ./modules/home;
          home-manager.extraSpecialArgs    = sharedArgs;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };

    # ── Linux (standalone home-manager — no NixOS required) ─────────────────
    # Install: nix run home-manager -- switch --flake .#${username}
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ./modules/home ];
      extraSpecialArgs = sharedArgs;
    };

  };
}
