{
  lib,
  stdenv,
  fetchzip,
  wxGTK32,
  fftw,
  fftwFloat,
  libz,
  libtiff,
  mklSupport ? true,
  mkl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctffind";
  version = "4.1.14";

  src = fetchzip {
    url = "https://grigoriefflab.umassmed.edu/system/tdf?path=ctffind-${finalAttrs.version}.tar.gz&file=1&type=node&id=26";
    hash = "sha256-LroMxHO+bEHqrE3hTOJwcma1D7jGlOH3vOcNRug8EKg=";
  };

  buildInputs = [
    mkl
    wxGTK32
    fftw
    fftw.dev
    fftwFloat
    fftwFloat.dev
    libz
    libtiff
    (lib.optional mklSupport mkl)
  ];
})
