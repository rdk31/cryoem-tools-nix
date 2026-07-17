{
  callPackage,
  fetchFromGitHub,
  lib,

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
  cudaPackages_12_8,
  python312Packages,
}:
let
  cudaPackages = cudaPackages_12_8;
  pythonPackages = python312Packages;

  skan = callPackage ./skan.nix { inherit pythonPackages; };
  starfile = callPackage ./starfile.nix { inherit pythonPackages; };
  mrcfile = callPackage ./mrcfile.nix { inherit pythonPackages; };
  relionClassRanker = callPackage ./class-ranker.nix { inherit cudaPackages pythonPackages; };
  topaz = callPackage ./topaz.nix { inherit cudaPackages pythonPackages; };

  pythonEnv = pythonPackages.python.withPackages (ps: [
    relionClassRanker
    topaz

    # required for trace_amyloids.py
    starfile
    mrcfile
    ps.matplotlib
    ps.scikit-image
    skan
    ps.opencv-python-headless
  ]);
in
cudaPackages.backendStdenv.mkDerivation rec {
  name = "relion";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "3dem";
    repo = "relion";
    rev = version;
    sha256 = "sha256-PxzuvMOIKoBjqgAFThbie/wZG0cvlEQEjUt6054zBuU=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    "-DFETCH_WEIGHTS=OFF"
    "-DCUDAToolkit_ROOT=${cudaPackages.cudatoolkit}"
    "-DPYTHON_EXE_PATH=${lib.getBin pythonEnv}/bin/python"
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

    cudaPackages.cuda_cudart

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

  propagatedBuildInputs = [ mpi ];

  postInstall = ''
    substituteInPlace $out/bin/relion_python_trace_amyloids --replace "relion_home=\"/build/source/build\"" "relion_home=\"$out\""
  '';
}
