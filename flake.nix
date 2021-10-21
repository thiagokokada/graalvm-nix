{
  description = "graalvm-musl";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    {
      overlay = final: prev: {
        i3pyblocks = self.defaultPackage;
      };
    } // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) lib callPackage Foundation;
      in
      {
        packages = import ./default.nix {
          inherit lib callPackage Foundation;
        };

        defaultPackage = self.packages.${system}.graalvm11-ce-musl;


        apps = {
          native-image = {
            type = "app";
            program = "${self.packages.${system}.graalvm11-ce}/bin/native-image";
          };

          native-image-musl = {
            type = "app";
            program = "${self.packages.${system}.graalvm11-ce-musl}/bin/native-image";
          };
        };

        defaultApp = self.apps.${system}.native-image-musl;

        devShell = pkgs.mkShell {
          name = "graalvm11-ce";
          buildInputs = [ self.defaultPackage.${system} ];
        };
      }
    );
}
