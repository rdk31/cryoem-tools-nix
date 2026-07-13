{
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "starfile";
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "teamtomo";
    repo = "starfile";
    rev = "v${version}";
    hash = "sha256-klGGDvfRIBAwUoPvEG5qYukzWO94otUmBoMIkjf307I=";
  };

  dependencies = with python3Packages; [
    numpy
    pandas
    pyarrow
  ];

  pyproject = true;
  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];
}
