{
  fetchFromGitHub,
  python3,
  python3Packages,
  cudaPackages,
}:
let
  torch = python3Packages.torch.override {
    cudaSupport = true;
    inherit cudaPackages;
  };
  torchvision = python3Packages.torchvision.override { inherit torch; };
in
python3Packages.buildPythonPackage {
  pname = "relion-classranker";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "3dem";
    repo = "relion-classranker";
    rev = "352adf8b690ba56e9f4073cfee41c8fcad3dfb81";
    hash = "sha256-rZ9q3oisXYFQaP/89ad9DQU5OEufil00JN17OLUV6Go=";
  };

  dependencies = with python3Packages; [
    numpy
    torch
    torchvision
  ];

  pyproject = true;
  build-system = [ python3Packages.setuptools ];
}
