{
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,

  imageio,
  matplotlib,
  networkx,
  numba,
  numpy,
  openpyxl,
  pandas,
  scikit-image,
  scipy,
  toolz,
  tqdm,
}:
buildPythonPackage (finalAttrs: {
  pname = "skan";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jni";
    repo = "skan";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RhY46LeELnAH+s2/j8yF3ifNeOFqdwS0l5JYqtlRvBc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    imageio
    matplotlib
    networkx
    numba
    numpy
    openpyxl
    pandas
    scikit-image
    scipy
    toolz
    tqdm
  ];
})
