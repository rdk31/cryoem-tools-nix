{
  description = "CryoEM tools flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = [
        "x86_64-linux"
      ];
      perSystem =
        { config, pkgs, ... }:
        let
          TEM-simulator = pkgs.callPackage ./pkgs/TEM-simulator.nix { };
          relion = pkgs.callPackage ./pkgs/relion.nix { };
        in
        {
          packages = {
            inherit TEM-simulator relion;
          };
          overlayAttrs = {
            inherit (config.packages) TEM-simulator relion;
          };
        };
    };
}
