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
  pname = "topaz-em";
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

  postPatch = ''
    substituteInPlace topaz/model/factory.py topaz/denoise.py topaz/commands/denoise3d.py \
      --replace-fail "import pkg_resources" "from importlib.resources import files" \
      --replace-fail "pkg_resources.resource_stream(pkg, path)" "files(pkg).joinpath(path).open('rb')"
  '';

  pythonRemoveDeps = [ "future" ];
}
