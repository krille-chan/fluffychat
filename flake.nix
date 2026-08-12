{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              android_sdk.accept_license = true;
            };
          };

          androidComposition = pkgs.androidenv.composeAndroidPackages {
            cmdLineToolsVersion = "8.0";
            platformToolsVersion = "37.0.0";
            buildToolsVersions = [
              "35.0.0"
              "36.0.0"
            ];
            platformVersions = [
              "31"
              "32"
              "33"
              "34"
              "35"
              "36"
            ];
            cmakeVersions = [ "3.22.1" ];
            includeNDK = true;
            ndkVersions = [
              "28.2.13676358"
              "27.0.12077973"
            ];
            useGoogleAPIs = true;
            includeEmulator = false;
          };

          androidSdk = androidComposition.androidsdk;

          linuxDeps = with pkgs; [
            gtk3
            glib
            libsecret
            webkitgtk_4_1
            fribidi.dev
          ];
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              flutter
              jdk21
              androidSdk
              rustup
              pkg-config
              cmake
              clang
            ];

            buildInputs = linuxDeps;

            env = {
              JAVA_HOME = "${pkgs.jdk21.home}";
              ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
              CPATH = "${pkgs.fribidi.dev}/include/fribidi:${pkgs.lib.makeSearchPath "include" linuxDeps}";
            };

            shellHook = ''
              FLUTTER_DEBUG_LIB="$PWD/build/linux/x64/debug/bundle/lib"
              FLUTTER_RELEASE_LIB="$PWD/build/linux/x64/release/bundle/lib"
              export LD_LIBRARY_PATH="$FLUTTER_DEBUG_LIB:$FLUTTER_RELEASE_LIB:${pkgs.lib.makeLibraryPath linuxDeps}:$LD_LIBRARY_PATH"
            '';
          };
        }
      );
    };
}
