{
  description = "NixOS Flake Configuration";

  inputs = {
    # Tracks the 26.05 stable channel.
    # Change to "nixos-unstable" if you prefer rolling release!
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}
