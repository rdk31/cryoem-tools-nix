{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  autoconf,
  automake,
  libtool,
  wxGTK32,
  libtiff,
  mklSupport ? true,
  mkl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cisTEM";
  version = "2.0.0-alpha";

  src = fetchFromGitHub {
    owner = "timothygrant80";
    repo = "cisTEM";
    rev = "d0d7261190a0e8dba8a82b3b2bea1a5c3365afea";
    sha256 = "sha256-zBBnDGABqX7hWukEN04vj53I2dBKHxoztLNt+bNJde4=";
  };

  buildInputs = [
    wxGTK32
    libtiff
    (lib.optional mklSupport mkl)
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    stdenv.cc
    coreutils
  ];
  enableParallelBuilding = true;
  MKLROOT = lib.optionalString mklSupport mkl;

  configurePhase = ''
    ./regenerate_project.b
    ./configure --prefix=$out --enable-experimental
  '';

})
