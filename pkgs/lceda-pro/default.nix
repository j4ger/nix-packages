{ stdenv, fetchzip, lib
  , glib
  , nss
  , nspr
  , at-spi2-atk
  , cups
  , dbus
  , libdrm
  , gtk3
  , pango
  , xorg
  , mesa
  , expat
  , libxkbcommon
  , alsa-lib
  , cairo
}:

stdenv.mkDerivation rec {
  pname = "lceda-pro";
  version = "2.1.59";
  src = fetchzip {
    url = "https://image.lceda.cn/files/lceda-pro-linux-x64-${version}.zip";
    hash = "sha256-rQp+71kAtMRNJdKFeBXGiVRC/ZPsiCXxgNr04XycIT0=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out $out/bin
    cp -rf lceda-pro $out/lceda-pro
    chmod -R 755 $out/lceda-pro
    ln -s $out/lceda-pro/lceda-pro $out/bin/lceda-pro

    runHook postInstall
  '';

  preFixup = let
    libPath = lib.makeLibraryPath ([
      glib
      nss
      nspr
      at-spi2-atk
      cups
      dbus
      libdrm
      gtk3
      pango
      mesa
      expat
      libxkbcommon
      alsa-lib
      cairo
    ] ++ (with xorg; [
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      libxcb
    ]));
  in ''
    patchelf \
      --set-rpath "${libPath}:$out/lceda-pro" \
      $out/lceda-pro/lceda-pro
  '';

  meta = with lib; {
    homepage = "https://lceda.cn/";
    description = "A high-efficiency PCB design suite";
    license = licenses.unfree;
    platforms = platforms.linux;
    # maintainers = [ j4ger ];
  };
}
