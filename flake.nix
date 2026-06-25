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
        packages.devin-desktop = pkgs.callPackage ./pkgs/devin-desktop { };

        # This creates the executable 'devin-desktop' app with the embedded FHS sandbox
        packages.default = pkgs.buildFHSEnv {
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

          runScript = "${self.packages.${system}.devin-desktop}/bin/devin-desktop";
        };

        # This lets you run 'nix develop' to test things interactively in an FHS shell
        devShells.default = (pkgs.buildFHSEnv {
          name = "devin-dev-env";
          targetPkgs = ps: with ps; [
            gtk3 nss mesa alsa-lib libsecret libXScrnSaver libXtst
            xdg-utils libxkbcommon dbus expat cups libxkbfile libXrandr
            libX11 libXi libxkbcommon libGL libXxf86vm glib libXtst nspr atk cairo pango
            libnotify libdbusmenu gtk2 gvfs vulkan-loader
          ];
          runScript = "bash";
        }).env;
      }
    );
}
