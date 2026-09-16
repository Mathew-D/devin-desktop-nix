{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "devin-desktop";
  version = "3.10.27";

  src = pkgs.fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64-deb/stable/bcbe88c734e882c54479decce8c34eabc9f8f8b0/Devin-linux-x64-3.10.27.deb";
    sha256 = "ec95611aa50fa6070f3dcdd16b57625c61a2e0453eed4390d8d05b02e9c81f17";
  };

  nativeBuildInputs = [
    pkgs.dpkg
    pkgs.autoPatchelfHook
    pkgs.makeWrapper
  ];

  buildInputs = with pkgs; [
    glib
    glib-networking
    libgpg-error
    libffi
    pcre2
    libselinux
    libsepol
    gtk3
    nss
    mesa
    alsa-lib
    libsecret
    libXScrnSaver
    libXtst
    libxkbcommon
    expat
    cups
    libxkbfile
    libXrandr
    libX11
    libXi
    libGL
    libXxf86vm
    nspr
    atk
    cairo
    pango
    webkitgtk_4_1
    libsoup_3
  ];

  unpackPhase = ''
    dpkg-deb --fsys-tarfile $src | tar --no-same-permissions --no-same-owner -xf -
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out/

    # Create symlink as done in aur-build
    install -dm755 $out/bin
    ln -sf "../share/devin-desktop/bin/devin-desktop" $out/bin/devin-desktop

    # Fix desktop file paths
    substituteInPlace $out/share/applications/devin-desktop.desktop \
      --replace-fail "/usr/share/devin-desktop/devin-desktop" "$out/bin/devin-desktop" \
      --replace-fail "Icon=devin-desktop" "Icon=$out/share/pixmaps/devin-desktop.png"

    substituteInPlace $out/share/applications/devin-desktop-url-handler.desktop \
      --replace-fail "/usr/share/devin-desktop/devin-desktop" "$out/bin/devin-desktop" \
      --replace-fail "Icon=devin-desktop" "Icon=$out/share/pixmaps/devin-desktop.png"
  '';

  meta = with pkgs.lib; {
    description = "A team of agents for every engineer — Devin Desktop";
    platforms = platforms.linux;
  };
}
