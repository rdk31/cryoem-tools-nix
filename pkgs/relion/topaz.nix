{
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  numpy,
  pandas,
  scikit-learn,
  scipy,
  pillow,
  torch,
}:
buildPythonPackage {
  pname = "topaz";
  version = "0.2.5a";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3dem";
    repo = "topaz";
    rev = "c8dd487cbf9d27139d0d430068033fb90dd9a393";
    hash = "sha256-YHpXf6XkwVGpNPlZSwzKbslfIGZpPU6u1CIqnOdQI9c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pandas
    scikit-learn
    scipy
    pillow
    torch
  ];

  patches = [ ./topaz.patch ];

  pythonRemoveDeps = [ "future" ];
}
