{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "devin-desktop";
  version = "3.5.17";

  src = pkgs.fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64-deb/stable/2c489dfc762456657db8662309c0d5e76e886397/Devin-linux-x64-3.5.17.deb";
    hash = "sha256-d5bfedb51e3325db91ab6450c11cf57171769548210b81960199afa5a286e954";
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
      --replace-fail "/usr/share/devin-desktop/devin-desktop" "$out/share/devin-desktop/devin-desktop" \
      --replace-fail "Icon=devin-desktop" "Icon=$out/share/pixmaps/devin-desktop.png"

    substituteInPlace $out/share/applications/devin-desktop-url-handler.desktop \
      --replace-fail "/usr/share/devin-desktop/devin-desktop" "$out/share/devin-desktop/devin-desktop" \
      --replace-fail "Icon=devin-desktop" "Icon=$out/share/pixmaps/devin-desktop.png"
  '';

  meta = with pkgs.lib; {
    description = "A team of agents for every engineer — Devin Desktop";
    platforms = platforms.linux;
  };
}
