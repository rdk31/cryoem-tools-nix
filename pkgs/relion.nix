{
  fetchFromGitHub,
  cmake,
  mpi,
  ghostscript,
  fftw,
  fftwFloat,
  fltk,
  xorg,
  libtiff,
  libpng,
  pbzip2,
  xz,
  zstd,
  cudaPackages,
  python3,
}:
let
  python3Packages = python3.pkgs;

  relionClassRanker = python3Packages.buildPythonPackage {
    pname = "relion-classranker";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "3dem";
      repo = "relion-classranker";
      rev = "352adf8b690ba56e9f4073cfee41c8fcad3dfb81";
      hash = "sha256-rZ9q3oisXYFQaP/89ad9DQU5OEufil00JN17OLUV6Go=";
    };

    dependencies =
      with python3Packages;
      let
        torchOverride = torch.override { cudaSupport = true; };
        torchVisionOverride = torchvision.override { torch = torchOverride; };
      in
      [
        numpy
        torchOverride
        torchVisionOverride
      ];

    pyproject = true;

    build-system = with python3Packages; [
      setuptools
    ];
  };

  python = python3.withPackages (
    ps: with ps; [
      relionClassRanker
    ]
  );
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
    xorg.libXft
    xorg.libX11

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
