{
  description = "froeb's nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";

      # Shared by every profile — hostname-independent so a fresh machine
      # can bootstrap without first matching a hardcoded name.
      baseModules = [
        ./modules/system.nix
        ./modules/homebrew.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.users.froeb = import ./modules/home.nix;
        }
      ];
    in
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;

      darwinConfigurations.base = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = baseModules;
      };

      # Work profile — adds Netlight-specific apps on top of base.
      darwinConfigurations.Netlight = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = baseModules ++ [ ./modules/netlight.nix ];
      };
    };
}
