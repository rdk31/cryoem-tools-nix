{
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  numpy,
  torch,
  torchvision,
}:
buildPythonPackage {
  pname = "relion-classranker";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3dem";
    repo = "relion-classranker";
    rev = "352adf8b690ba56e9f4073cfee41c8fcad3dfb81";
    hash = "sha256-rZ9q3oisXYFQaP/89ad9DQU5OEufil00JN17OLUV6Go=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    torch
    torchvision
  ];
}
