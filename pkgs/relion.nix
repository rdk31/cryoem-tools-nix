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
  cudaPackages_12_8,
  python3,
  python3Packages,
}:
let
  torch = python3Packages.torch.override { cudaSupport = true; };
  torchvision = python3Packages.torchvision.override { torch = torch; };

  skan = python3Packages.buildPythonPackage rec {
    pname = "skan";
    version = "0.13.1";

    src = fetchFromGitHub {
      owner = "jni";
      repo = "skan";
      rev = "v${version}";
      hash = "sha256-RhY46LeELnAH+s2/j8yF3ifNeOFqdwS0l5JYqtlRvBc=";
    };

    dependencies = with python3Packages; [
      imageio
      matplotlib
      networkx
      numba
      numpy
      pandas
      openpyxl
      scikit-image
      scipy
      toolz
      tqdm
    ];

    pyproject = true;

    build-system = with python3Packages; [
      setuptools
      setuptools-scm
    ];
  };

  starfile = python3Packages.buildPythonPackage rec {
    pname = "starfile";
    version = "0.5.13";

    src = fetchFromGitHub {
      owner = "teamtomo";
      repo = "starfile";
      rev = "v${version}";
      hash = "sha256-klGGDvfRIBAwUoPvEG5qYukzWO94otUmBoMIkjf307I=";
    };

    dependencies = with python3Packages; [
      numpy
      pandas
      pyarrow
    ];

    pyproject = true;

    build-system = with python3Packages; [
      hatchling
      hatch-vcs
    ];
  };

  mrcfile = python3Packages.buildPythonPackage rec {
    pname = "mrcfile";
    version = "1.5.4";

    src = fetchFromGitHub {
      owner = "ccpem";
      repo = "mrcfile";
      rev = "v${version}";
      hash = "sha256-513R/R1Sa4lZq5a1Kf3phmmuCNz6YTp3wBdOXwidfkA=";
    };

    dependencies = with python3Packages; [
      numpy
    ];

    pyproject = true;

    build-system = with python3Packages; [
      setuptools
    ];
  };

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
      [
        numpy
      ]
      ++ [
        torch
        torchvision
      ];

    pyproject = true;

    build-system = with python3Packages; [
      setuptools
    ];
  };

  topaz = python3Packages.buildPythonPackage {
    pname = "topaz";
    version = "0.2.5a";

    src = fetchFromGitHub {
      owner = "3dem";
      repo = "topaz";
      rev = "c8dd487cbf9d27139d0d430068033fb90dd9a393";
      hash = "sha256-YHpXf6XkwVGpNPlZSwzKbslfIGZpPU6u1CIqnOdQI9c=";
    };

    pythonRemoveDeps = [ "future" ];

    dependencies =
      with python3Packages;
      [
        numpy
        pandas
        scikit-learn
        scipy
        pillow
      ]
      ++ [
        torch
      ];

    pyproject = true;

    build-system = with python3Packages; [
      setuptools
    ];
  };

  python = python3.withPackages (ps: [
    relionClassRanker
    topaz

    # trace_amyloids.py
    starfile
    mrcfile
    ps.matplotlib
    ps.scikit-image
    skan
    ps.opencv-python-headless
  ]);
in
cudaPackages_12_8.backendStdenv.mkDerivation rec {
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
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages_12_8.cudatoolkit}"
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

  postInstall = ''
    substituteInPlace $out/bin/relion_python_trace_amyloids --replace "relion_home=\"/build/source/build\"" "relion_home=\"$out\""
  '';
}
