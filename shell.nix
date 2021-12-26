{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  graalvmCEPackages = import ./default.nix { inherit pkgs; };
  graalvm = graalvmCEPackages.graalvm11-ce;
in
mkShell {
  buildInputs = [
    graalvm
  ];
  shellHook = ''
    export GRAALVM_HOME=${graalvm}
  '';
}
