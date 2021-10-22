{
  description = "graalvm-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    {
      overlay = final: prev: {
        graalvmCEPackages = self.packages;
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
        apps =
          let
            inherit (flake-utils.lib) mkApp;
          in
          with self.packages.${system}; {
            "11/glibc/latest/native-image" = self.apps.${system}."11/glibc/21_3_0/native-image";
            "11/musl/latest/native-image" = self.apps.${system}."11/musl/21_3_0/native-image";

            "17/glibc/latest/native-image" = self.apps.${system}."17/glibc/21_3_0/native-image";
            "17/musl/latest/native-image" = self.apps.${system}."17/musl/21_3_0/native-image";

            "11/glibc/21_2_0/native-image" = mkApp { drv = graalvm11-ce-21_2_0; name = "native-image"; };
            "11/glibc/21_3_0/native-image" = mkApp { drv = graalvm11-ce; name = "native-image"; };

            "11/musl/21_2_0/native-image" = mkApp { drv = graalvm11-ce-musl-21_2_0; name = "native-image"; };
            "11/musl/21_3_0/native-image" = mkApp { drv = graalvm11-ce-musl; name = "native-image"; };

            "17/glibc/21_2_0/native-image" = mkApp { drv = graalvm17-ce-21_2_0; name = "native-image"; };
            "17/glibc/21_3_0/native-image" = mkApp { drv = graalvm17-ce; name = "native-image"; };

            "17/musl/21_2_0/native-image" = mkApp { drv = graalvm17-ce-musl-21_2_0; name = "native-image"; };
            "17/musl/21_3_0/native-image" = mkApp { drv = graalvm17-ce-musl; name = "native-image"; };
          };

        defaultApp = self.apps.${system}."11/musl/latest/native-image";

        devShell = import ./shell.nix { inherit pkgs; };
      }
    );
}
