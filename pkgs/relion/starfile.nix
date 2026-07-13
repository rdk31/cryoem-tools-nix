{
  fetchFromGitHub,
  pythonPackages,
}:
pythonPackages.buildPythonPackage rec {
  pname = "starfile";
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "teamtomo";
    repo = "starfile";
    rev = "v${version}";
    hash = "sha256-klGGDvfRIBAwUoPvEG5qYukzWO94otUmBoMIkjf307I=";
  };

  dependencies = with pythonPackages; [
    numpy
    pandas
    pyarrow
  ];

  pyproject = true;
  build-system = with pythonPackages; [
    hatchling
    hatch-vcs
  ];
}
