{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "devin-desktop";
  version = "3.2.23";

  src = pkgs.fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64-deb/stable/3bd47f77998b2e526fed61a11015b78d6205f295/Devin-linux-x64-${version}.deb";
    hash = "sha256-b83f89c28f3a5657f58ff91e2c909bdabd25d803e09f678d2ff1e5d9b84f9b7f";
  };

  nativeBuildInputs = [
    pkgs.dpkg
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out/

    # Create symlink as done in aur-build
    install -dm755 $out/bin
    ln -sf "/usr/share/devin-desktop/bin/devin-desktop" $out/bin/devin-desktop
  '';

  meta = with pkgs.lib; {
    description = "A team of agents for every engineer — Devin Desktop";
    platforms = platforms.linux;
  };
}
