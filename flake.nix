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
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = [ "x86_64-linux" ];
      flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix { checks = self.packages; };
      perSystem =
        { config, pkgs, ... }:
        {
          packages = {
            TEM-simulator = pkgs.callPackage ./pkgs/TEM-simulator.nix { };
            relion = pkgs.callPackage ./pkgs/relion.nix { };
            ctffind = pkgs.callPackage ./pkgs/ctffind.nix { };
            cisTEM = pkgs.callPackage ./pkgs/cisTEM.nix { };
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
