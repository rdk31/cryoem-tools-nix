{
  stdenv,
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
}:
stdenv.mkDerivation rec {
  name = "relion";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "3dem";
    repo = "relion";
    rev = version;
    sha256 = "sha256-NDqqgQ/De7PECZ8hRvMCK+1htDyqXo6aIdUOcJ7abiE=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFETCH_WEIGHTS=OFF"
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
  ];

  hardeningDisable = [ "format" ];

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
