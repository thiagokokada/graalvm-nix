{
  description = "graalvm-nix";

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
      in
      {
        packages = import ./default.nix { inherit pkgs; };

        defaultPackage = self.packages.${system}.graalvm11-ce-musl;

        # TODO: generate this programatically
        apps = rec {
          "11/glibc/current/native-image" = self.apps.${system}."11/glibc/21_3_0/native-image";
          "11/musl/current/native-image" = self.apps.${system}."11/musl/21_3_0/native-image";
          "17/glibc/current/native-image" = self.apps.${system}."17/glibc/21_3_0/native-image";
          "17/musl/current/native-image" = self.apps.${system}."17/musl/21_3_0/native-image";

          "11/glibc/21_2_0/native-image" = {
            type = "app";
            program = "${self.packages.${system}.graalvm11-ce-21_2_0}/bin/native-image";
          };

          "11/glibc/21_3_0/native-image" = {
            type = "app";
            program = "${self.packages.${system}.graalvm11-ce}/bin/native-image";
          };

          "11/musl/21_2_0/native-image" = {
            type = "app";
            program = "${self.packages.${system}.graalvm11-ce-musl-21_2_0}/bin/native-image";
          };

          "11/musl/21_3_0/native-image" = {
            type = "app";
            program = "${self.packages.${system}.graalvm11-ce-musl}/bin/native-image";
          };

          "17/glibc/21_2_0/native-image" = {
            type = "app";
            program = "${self.packages.${system}.graalvm17-ce-21_2_0}/bin/native-image";
          };

          "17/glibc/21_3_0/native-image" = {
            type = "app";
            program = "${self.packages.${system}.graalvm17-ce}/bin/native-image";
          };

          "17/musl/21_2_0/native-image" = {
            type = "app";
            program = "${self.packages.${system}.graalvm17-ce-musl-21_2_0}/bin/native-image";
          };

          "17/musl/21_3_0/native-image" = {
            type = "app";
            program = "${self.packages.${system}.graalvm17-ce-musl}/bin/native-image";
          };
        };

        defaultApp = self.apps.${system}."11/musl/current/native-image";

        devShell = pkgs.mkShell {
          name = "graalvm11-ce";
          buildInputs = [ self.defaultPackage.${system} ];
        };
      }
    );
}
