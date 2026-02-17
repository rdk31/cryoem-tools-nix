{
  fetchFromGitHub,
  cmake,
  mpi,
  ghostscript,
  fftw,
  fftwFloat,
  fltk,
  libxft,
  libx11,
  libtiff,
  libpng,
  pbzip2,
  xz,
  zstd,
  cudaPackages,
  python311,
  python311Packages,
}:
let
  relionClassRanker = python311Packages.buildPythonPackage {
    pname = "relion-classranker";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "3dem";
      repo = "relion-classranker";
      rev = "352adf8b690ba56e9f4073cfee41c8fcad3dfb81";
      hash = "sha256-rZ9q3oisXYFQaP/89ad9DQU5OEufil00JN17OLUV6Go=";
    };

    dependencies = with python311Packages; [
      numpy
      torch-bin
      torchvision-bin
    ];

    pyproject = true;

    build-system = with python311Packages; [
      setuptools
    ];
  };

  topaz = python311Packages.buildPythonPackage {
    pname = "topaz";
    version = "0.2.5a";

    src = fetchFromGitHub {
      owner = "3dem";
      repo = "topaz";
      rev = "c8dd487cbf9d27139d0d430068033fb90dd9a393";
      hash = "sha256-YHpXf6XkwVGpNPlZSwzKbslfIGZpPU6u1CIqnOdQI9c=";
    };

    dependencies = with python311Packages; [
      torch-bin
      numpy
      pandas
      scikit-learn
      scipy
      pillow
      future
    ];

    pyproject = true;

    build-system = with python311Packages; [
      setuptools
    ];
  };

  python = python311.withPackages (ps: [
    relionClassRanker
    topaz
  ]);
in
cudaPackages.backendStdenv.mkDerivation rec {
  name = "relion";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "3dem";
    repo = "relion";
    rev = version;
    sha256 = "sha256-wyNlz/ZXUlYUAnHGOlriVE1VP5vo5sbKFn4V/UHiLcg=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    "-DFETCH_WEIGHTS=OFF"
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
    "-DPYTHON_EXE_PATH=${python}/bin/${python.executable}"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" # https://github.com/NixOS/nixpkgs/issues/445447
  ];

  hardeningDisable = [ "format" ];
  dontStrip = true;

  buildInputs = [
    mpi

    ghostscript

    fltk
    libxft
    libx11

    fftw
    fftw.dev
    fftwFloat
    fftwFloat.dev

    libtiff
    libpng
    pbzip2
    xz
    zstd
  ];
}
