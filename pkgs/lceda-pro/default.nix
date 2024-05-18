{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "lceda-pro";
  version = "2.1.59";
  src = pkgs.fetchzip {
    url = "https://image.lceda.cn/files/lceda-pro-linux-x64-${version}.zip";
    hash = "";
  };

  installPhase = ''
    mkdir $out
    cp -rf lceda-pro $out/opt/lceda-pro
    chmod -R 755 $out/opt/lceda-pro
  '';
}
