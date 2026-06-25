{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "devin-desktop";
  version = "3.2.23";

  src = pkgs.fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64-deb/stable/3bd47f77998b2e526fed61a11015b78d6205f295/Devin-linux-x64-3.2.23.deb";
    hash = "sha256-uD+Jwo86Vlf1j/keLJCb2r0l2APgn2eNL/Hl2bhPm38=";
  };

  nativeBuildInputs = [
    pkgs.dpkg
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
  '';

  meta = with pkgs.lib; {
    description = "A team of agents for every engineer — Devin Desktop";
    platforms = platforms.linux;
  };
}
