{ pkgs ? import <nixpkgs> { }, ... }:

let
  inherit (pkgs) callPackage lib Foundation;
  mkGraal = opts: callPackage (import ./mkGraal.nix opts) {
    inherit Foundation;
  };
in
{
  inherit mkGraal;

  graalvm11-ce = mkGraal rec {
    version = "21.3.0";
    javaVersion = "11";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };

  graalvm11-ce-21_2_0 = mkGraal rec {
    version = "21.2.0";
    javaVersion = "11";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    hashes = import ./resources/hashes-21_2_0.nix;
  };

  graalvm11-ce-musl = mkGraal rec {
    version = "21.3.0";
    javaVersion = "11";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    useMusl = true;
  };

  graalvm11-ce-musl-21_2_0 = mkGraal rec {
    version = "21.2.0";
    javaVersion = "11";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    useMusl = true;
    hashes = import ./resources/hashes-21_2_0.nix;
  };

  # TODO: fix aarch64-linux, failing during Native Image compilation
  # "Caused by: java.io.IOException: Cannot run program
  # "/nix/store/1q1mif7h3lgxdaxg6j39hli5azikrfla-gcc-wrapper-9.3.0/bin/gcc" (in
  # directory"/tmp/SVM-4194439592488143713"): error=0, Failed to exec spawn
  # helper: pid: 19865, exit value: 1"
  graalvm17-ce = mkGraal rec {
    version = "21.3.0";
    javaVersion = "17";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

  graalvm17-ce-musl = mkGraal rec {
    version = "21.3.0";
    javaVersion = "17";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    useMusl = true;
  };
}
