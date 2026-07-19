{
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  numpy,
}:
buildPythonPackage (finalAttrs: {
  pname = "mrcfile";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ccpem";
    repo = "mrcfile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-513R/R1Sa4lZq5a1Kf3phmmuCNz6YTp3wBdOXwidfkA=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];
})
