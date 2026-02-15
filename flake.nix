{
  description = "CryoEM tools flake";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos-cuda.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
          ctffind = pkgs.callPackage ./pkgs/ctffind.nix { };
          cisTEM = pkgs.callPackage ./pkgs/cisTEM.nix { };
        in
        {
          packages = {
            inherit
              TEM-simulator
              relion
              ctffind
              cisTEM
              ;
          };
          overlayAttrs = {
            inherit (config.packages)
              TEM-simulator
              relion
              ctffind
              cisTEM
              ;
          };
        };
    };
}
