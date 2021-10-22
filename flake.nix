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
        apps = with self.packages.${system};
          let
            mkApp = package: program:
              {
                type = "app";
                program = "${package}/bin/${program}";
              };
          in
          {
            "11/glibc/latest/native-image" = self.apps.${system}."11/glibc/21_3_0/native-image";
            "11/musl/latest/native-image" = self.apps.${system}."11/musl/21_3_0/native-image";

            "17/glibc/latest/native-image" = self.apps.${system}."17/glibc/21_3_0/native-image";
            "17/musl/latest/native-image" = self.apps.${system}."17/musl/21_3_0/native-image";

            "11/glibc/21_2_0/native-image" = mkApp graalvm11-ce-21_2_0 "native-image";
            "11/glibc/21_3_0/native-image" = mkApp graalvm11-ce "native-image";

            "11/musl/21_2_0/native-image" = mkApp graalvm11-ce-musl-21_2_0 "native-image";
            "11/musl/21_3_0/native-image" = mkApp graalvm11-ce-musl "native-image";

            "17/glibc/21_2_0/native-image" = mkApp graalvm17-ce-21_2_0 "native-image";
            "17/glibc/21_3_0/native-image" = mkApp graalvm17-ce "native-image";

            "17/musl/21_2_0/native-image" = mkApp graalvm17-ce-musl-21_2_0 "native-image";
            "17/musl/21_3_0/native-image" = mkApp graalvm17-ce-musl "native-image";
          };

        defaultApp = self.apps.${system}."11/musl/latest/native-image";

        devShell = import ./shell.nix { inherit pkgs; };
      }
    ) // {
      overlay = (final: prev: {
        graalvmCEPackages = self.packages;
      });
    };
}
