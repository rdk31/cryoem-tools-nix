{
  stdenv,
  fetchzip,
  fftw,
  gcc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "TEM-simulator";
  version = "1.3";

  src = fetchzip {
    url = "mirror://sourceforge/tem-simulator/TEM-simulator_${finalAttrs.version}.zip";
    hash = "sha256-QuZCudYX2hoOsYxyvPvWBzF/fUr60+1zCA1XiIiQwUM=";
  };

  buildInputs = [
    fftw
  ];

  patchPhase = ''
    substituteInPlace src/Makefile \
      --replace-fail /usr/bin/gcc ${gcc}/bin/gcc
  '';

  buildPhase = ''
    cd src
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp TEM-simulator $out/bin/
  '';
})
