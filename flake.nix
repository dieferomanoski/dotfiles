{
  description = "macOS dotfiles — nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    # ── The only place you need to edit when setting up on a new machine ──────
    username = "ktt";          # run:  whoami
    hostname = "ktt";          # run:  scutil --get ComputerName
    system   = "aarch64-darwin"; # arm64 → aarch64-darwin  |  x86_64 → x86_64-darwin
    # ─────────────────────────────────────────────────────────────────────────
  in {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit system;

      modules = [
        ./modules/darwin

        # Inject username + hostname into every darwin module via _module.args
        { _module.args = { inherit username hostname; }; }

        home-manager.darwinModules.home-manager
        {
          system.primaryUser = username;

          home-manager.useGlobalPkgs       = true;
          home-manager.useUserPackages     = true;
          home-manager.users.${username}   = import ./modules/home;
          home-manager.extraSpecialArgs    = { inherit username hostname; };
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
