{
  fetchFromGitHub,
  pythonPackages,
}:
pythonPackages.buildPythonPackage rec {
  pname = "mrcfile";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "ccpem";
    repo = "mrcfile";
    rev = "v${version}";
    hash = "sha256-513R/R1Sa4lZq5a1Kf3phmmuCNz6YTp3wBdOXwidfkA=";
  };

  dependencies = [ pythonPackages.numpy ];

  pyproject = true;
  build-system = [ pythonPackages.setuptools ];
}
