{
  lib,
  stdenv,
  fetchzip,
  wxwidgets_3_3,
  fftw,
  fftwFloat,
  libz,
  libtiff,
  libjpeg,
  mklSupport ? stdenv.hostPlatform.isx86_64,
  mkl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ctffind";
  version = "4.1.14";

  src = fetchzip {
    url = "https://grigoriefflab.umassmed.edu/system/tdf?path=ctffind-${finalAttrs.version}.tar.gz&file=1&type=node&id=26";
    hash = "sha256-LroMxHO+bEHqrE3hTOJwcma1D7jGlOH3vOcNRug8EKg=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
    substituteInPlace src/core/matrix.cpp \
      --replace-fail \
        '#define _AL_SINCOS(x, s, c)  __asm__ ("fsincos" : "=t" (c), "=u" (s) : "0" (x))' \
        '#define _AL_SINCOS(x, s, c) do { (s) = sin(x); (c) = cos(x); } while (0)'
  '';

  buildInputs = [
    wxwidgets_3_3
    fftw
    fftw.dev
    fftwFloat
    fftwFloat.dev
    libz
    libtiff
    libjpeg
    (lib.optional mklSupport mkl)
  ];
  enableParallelBuilding = true;
})
