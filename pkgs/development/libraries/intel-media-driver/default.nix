{ stdenv, fetchFromGitHub
, cmake, pkg-config
, libva, libpciaccess, intel-gmmlib, libX11
}:

stdenv.mkDerivation rec {
  pname = "intel-media-driver";
  version = "20.4.0";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "media-driver";
    rev    = "intel-media-${version}";
    sha256 = "0nah3h3s6hqbgz1wqp5j1grzq0q939wbh4b9d27dmb4wy6ma41sl";
  };

  cmakeFlags = [
    "-DINSTALL_DRIVER_SYSCONF=OFF"
    "-DLIBVA_DRIVERS_PATH=${placeholder "out"}/lib/dri"
    # Works only on hosts with suitable CPUs.
    "-DMEDIA_RUN_TEST_SUITE=OFF"
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libva libpciaccess intel-gmmlib libX11 ];

  meta = with stdenv.lib; {
    description = "Intel Media Driver for VAAPI — Broadwell+ iGPUs";
    longDescription = ''
      The Intel Media Driver for VAAPI is a new VA-API (Video Acceleration API)
      user mode driver supporting hardware accelerated decoding, encoding, and
      video post processing for GEN based graphics hardware.
    '';
    homepage = "https://github.com/intel/media-driver";
    changelog = "https://github.com/intel/media-driver/releases/tag/intel-media-${version}";
    license = with licenses; [ bsd3 mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos jfrankenau ];
  };
}
