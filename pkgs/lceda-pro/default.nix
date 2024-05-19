{ stdenv, fetchzip, lib, makeDesktopItem, makeWrapper
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
  , xdg-utils
  , libGL
}:

let
  desktopEntry = makeDesktopItem {
    name = "lceda-pro";
    desktopName = "LCEDA Pro";
    exec = "lceda-pro %u";
    icon = "LCEDA";
    categories = [ "Development" ];
    extraConfig = {
      "Name[zh_CN]" = "立创EDA专业版";
    };
  };
in
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

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -rf lceda-pro $out/lceda-pro
    chmod -R 755 $out/lceda-pro

    makeWrapper $out/lceda-pro/lceda-pro $out/bin/lceda-pro \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ libGL ]}" \
      --set PATH "${lib.makeBinPath [xdg-utils]}"

    mkdir -p $out/share/icons/{64x64,64x64@2,128x128,128x128@2,256x256,256x256@2,512x512,512x512@2}/apps
    ln -s $out/lceda-pro/icon/icon_64x64.png $out/share/icons/64x64/apps/lceda.png
    ln -s $out/lceda-pro/icon/icon_64x64@2x.png $out/share/icons/64x64@2/apps/lceda.png
    ln -s $out/lceda-pro/icon/icon_128x128.png $out/share/icons/128x128/apps/lceda.png
    ln -s $out/lceda-pro/icon/icon_128x128@2x.png $out/share/icons/128x128@2/apps/lceda.png
    ln -s $out/lceda-pro/icon/icon_256x256.png $out/share/icons/256x256/apps/lceda.png
    ln -s $out/lceda-pro/icon/icon_256x256@2x.png $out/share/icons/256x256@2/apps/lceda.png
    ln -s $out/lceda-pro/icon/icon_512x512.png $out/share/icons/512x512/apps/lceda.png
    ln -s $out/lceda-pro/icon/icon_512x512@2x.png $out/share/icons/512x512@2/apps/lceda.png

    mkdir -p $out/share/applications
    ln -s "${desktopEntry}" "$out/share/applications/lceda-pro.desktop"

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
