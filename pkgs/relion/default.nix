{
  lib,
  fetchFromGitHub,

  python312,
  cudaPackages_12_8,

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
}:
let
  cudaPackages = cudaPackages_12_8;
  python = (
    python312.override {
      packageOverrides = final: prev: {
        torch = (
          prev.torch.override {
            cudaSupport = true;
            inherit cudaPackages;
          }
        );

        skan = final.callPackage ./skan.nix { };
        starfile = final.callPackage ./starfile.nix { };
        mrcfile = final.callPackage ./mrcfile.nix { };
        relionClassRanker = final.callPackage ./class-ranker.nix { };
        topaz = final.callPackage ./topaz.nix { };
      };
    }
  );

  pythonEnv = python.withPackages (
    ps: with ps; [
      relionClassRanker
      topaz

      # required for trace_amyloids.py
      starfile
      mrcfile
      matplotlib
      scikit-image
      skan
      opencv-python-headless
    ]
  );
in
cudaPackages.backendStdenv.mkDerivation (finalAttrs: {
  name = "relion";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "3dem";
    repo = "relion";
    rev = finalAttrs.version;
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

  enableParallelBuilding = true;
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
})
