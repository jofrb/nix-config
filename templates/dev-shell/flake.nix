{
  description = "Dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # Add project-specific tools here, e.g.:
          # nodejs_22
          # go
          # rustup
        ];

        shellHook = ''
          echo "dev shell ready"
        '';
      };
    };
}
