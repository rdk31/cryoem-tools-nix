# CryoEM-tools-nix

Nix flake for Cryo-EM tools.

## Available Packages

| name          | version     | homepage                                      |
| ------------- | ----------- | --------------------------------------------- |
| TEM-simulator | 1.3         | <https://tem-simulator.sourceforge.net/>      |
| relion        | 5.0.1       | <https://relion.readthedocs.io/en/latest/>    |
| ctffind       | 4.1.14      | <https://grigoriefflab.umassmed.edu/ctffind4> |
| cisTEM        | 2.0.0-alpha | <https://cistem.org/>                         |

## Installation

In your flake.nix:

```nix
{
  inputs = {
    cryoem-tools-nix.url = "github:rdk31/cryoem-tools-nix";
  };
}
```

In your system configuration:

```nix
{ inputs, pkgs, ... }: # Make sure the flake inputs are in your system's config
{
  nixpkgs.overlays = [ inputs.cryoem-tools-nix.overlays.default ];

  environment.systemPackages = with pkgs; [
    relion
  ];
}
```
