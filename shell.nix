{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  graalvmCEPackages = import ./default.nix { inherit pkgs; };
in
mkShell {
  buildInputs = [
    graalvmCEPackages.graalvm11-ce
  ];
}
