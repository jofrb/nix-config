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

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }: {
    darwinConfigurations."MacGyverBook-pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./modules/system.nix
        ./modules/packages.nix
        ./modules/homebrew.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs        = true;
          home-manager.useUserPackages      = true;
          home-manager.backupFileExtension  = "bak";
          home-manager.users.froeb          = import ./modules/home.nix;
        }
      ];
    };
  };
}
