{ pkgs, ... }:

{
  # Packages available to all users system-wide.
  # User-specific packages live in modules/home.nix instead.
  environment.systemPackages = with pkgs; [
    curl
    git
    wget
  ];
}
