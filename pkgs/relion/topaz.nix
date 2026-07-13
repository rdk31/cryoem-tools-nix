{
  fetchFromGitHub,
  python3,
  python3Packages,
  cudaPackages,
}:
let
  torch = python3Packages.torch.override {
    cudaSupport = true;
    inherit cudaPackages;
  };
in
python3Packages.buildPythonPackage {
  pname = "topaz";
  version = "0.2.5a";

  src = fetchFromGitHub {
    owner = "3dem";
    repo = "topaz";
    rev = "c8dd487cbf9d27139d0d430068033fb90dd9a393";
    hash = "sha256-YHpXf6XkwVGpNPlZSwzKbslfIGZpPU6u1CIqnOdQI9c=";
  };

  pythonRemoveDeps = [ "future" ];
  patches = [ ./topaz.patch ];

  dependencies = with python3Packages; [
    numpy
    pandas
    scikit-learn
    scipy
    pillow
    torch
  ];

  pyproject = true;
  build-system = [ python3Packages.setuptools ];
}
