{
  buildPythonPackage,
  fetchFromGitHub,

  hatchling,
  hatch-vcs,

  numpy,
  pandas,
  pyarrow,

  typing-extensions,
}:
buildPythonPackage (finalAttrs: {
  pname = "starfile";
  version = "0.5.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "teamtomo";
    repo = "starfile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-klGGDvfRIBAwUoPvEG5qYukzWO94otUmBoMIkjf307I=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    numpy
    pandas
    pyarrow
  ];

  nativeCheckInputs = [ typing-extensions ];
})
