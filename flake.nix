{
  description = "Devin Desktop FHS environment flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true; # Needed for Devin Desktop
        };
      in
      {
        # Build the devin-desktop package from the .deb file
        packages.devin-desktop-unwrapped = pkgs.callPackage ./pkgs/devin-desktop { };

        # This creates the executable 'devin-desktop' app with the embedded FHS sandbox
        packages.devin-desktop = pkgs.buildFHSEnv {
          name = "devin-desktop";

          targetPkgs = ps: with ps; [
            # Core runtime dependencies from aur-build
            gtk3
            nss
            mesa
            alsa-lib
            libsecret
            libXScrnSaver
            libXtst
            xdg-utils
            libxkbcommon
            dbus
            expat
            cups
            libxkbfile
            libXrandr

            # Standard Electron app runtime dependencies
            libX11
            libXi
            libxkbcommon
            libGL
            libXxf86vm
            glib
            glib-networking
            libgpg-error
            libffi
            pcre2
            libselinux
            libsepol
            libXtst
            nspr
            atk
            cairo
            pango

            # Optional runtime dependencies
            libnotify
            libdbusmenu
            gtk2
            gvfs
            vulkan-loader
          ];

          runScript = "${self.packages.${system}.devin-desktop-unwrapped}/bin/devin-desktop";

          extraInstallCommands = ''
            mkdir -p $out/share/applications
            mkdir -p $out/share/pixmaps

            # Copy desktop files from unwrapped package
            cp ${self.packages.${system}.devin-desktop-unwrapped}/share/applications/*.desktop $out/share/applications/

            # Copy icon
            cp ${self.packages.${system}.devin-desktop-unwrapped}/share/pixmaps/devin-desktop.png $out/share/pixmaps/

            # Fix desktop file Exec paths to point to FHS wrapper
            substituteInPlace $out/share/applications/devin-desktop.desktop \
              --replace-fail "${self.packages.${system}.devin-desktop-unwrapped}/share/devin-desktop/devin-desktop" "$out/bin/devin-desktop" \
              --replace-fail "${self.packages.${system}.devin-desktop-unwrapped}/share/pixmaps/devin-desktop.png" "$out/share/pixmaps/devin-desktop.png"

            substituteInPlace $out/share/applications/devin-desktop-url-handler.desktop \
              --replace-fail "${self.packages.${system}.devin-desktop-unwrapped}/share/devin-desktop/devin-desktop" "$out/bin/devin-desktop" \
              --replace-fail "${self.packages.${system}.devin-desktop-unwrapped}/share/pixmaps/devin-desktop.png" "$out/share/pixmaps/devin-desktop.png"
          '';
        };

        packages.default = self.packages.${system}.devin-desktop;

        # This lets you run 'nix develop' to test things interactively in an FHS shell
        devShells.default = (pkgs.buildFHSEnv {
          name = "devin-dev-env";
          targetPkgs = ps: with ps; [
            gtk3 nss mesa alsa-lib libsecret libXScrnSaver libXtst
            xdg-utils libxkbcommon dbus expat cups libxkbfile libXrandr
            libX11 libXi libxkbcommon libGL libXxf86vm glib glib-networking libgpg-error libffi libpcre2 libselinux libsepol libXtst nspr atk cairo pango
            libnotify libdbusmenu gtk2 gvfs vulkan-loader
          ];
          runScript = "bash";
        }).env;
      }
    );
}
