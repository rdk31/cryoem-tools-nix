{
  fetchFromGitHub,
  pythonPackages,
}:
pythonPackages.buildPythonPackage rec {
  pname = "skan";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "jni";
    repo = "skan";
    rev = "v${version}";
    hash = "sha256-RhY46LeELnAH+s2/j8yF3ifNeOFqdwS0l5JYqtlRvBc=";
  };

  dependencies = with pythonPackages; [
    imageio
    matplotlib
    networkx
    numba
    numpy
    pandas
    openpyxl
    scikit-image
    scipy
    toolz
    tqdm
  ];

  pyproject = true;
  build-system = with pythonPackages; [
    setuptools
    setuptools-scm
  ];
}
