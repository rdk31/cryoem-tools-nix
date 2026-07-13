{
  fetchFromGitHub,
  pythonPackages,
  cudaPackages,
}:
let
  torch = pythonPackages.torch.override {
    cudaSupport = true;
    inherit cudaPackages;
  };
  torchvision = pythonPackages.torchvision.override { inherit torch; };
in
pythonPackages.buildPythonPackage {
  pname = "relion-classranker";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "3dem";
    repo = "relion-classranker";
    rev = "352adf8b690ba56e9f4073cfee41c8fcad3dfb81";
    hash = "sha256-rZ9q3oisXYFQaP/89ad9DQU5OEufil00JN17OLUV6Go=";
  };

  dependencies = with pythonPackages; [
    numpy
    torch
    torchvision
  ];

  pyproject = true;
  build-system = [ pythonPackages.setuptools ];
}
