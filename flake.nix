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

        defaultPackage = self.packages.${system}.graalvm11-ce;

        apps =
          let
            inherit (flake-utils.lib) mkApp;
            inherit (nixpkgs.lib) foldr recursiveUpdate;

            mergeAttrsList = attrsList: foldr recursiveUpdate { } attrsList;
            mkApps = { drv, ns, names ? import ./resources/bin-names.nix }:
              (mergeAttrsList
                (map (name: { "${ns}/${name}" = (mkApp { inherit drv name; }); }) names));
          in
          with self.packages.${system};
          mergeAttrsList [
            {
              "11/glibc/latest/native-image" = self.apps.${system}."11/glibc/21_3_0/native-image";
              "11/musl/latest/native-image" = self.apps.${system}."11/musl/21_3_0/native-image";

              "17/glibc/latest/native-image" = self.apps.${system}."17/glibc/21_3_0/native-image";
              "17/musl/latest/native-image" = self.apps.${system}."17/musl/21_3_0/native-image";
            }

            (mkApps { drv = graalvm11-ce-21_2_0; ns = "11/glibc/21_2_0"; })
            (mkApps { drv = graalvm11-ce; ns = "11/glibc/21_3_0"; })

            (mkApps { drv = graalvm11-ce-musl-21_2_0; ns = "11/musl/21_2_0"; })
            (mkApps { drv = graalvm11-ce-musl; ns = "11/musl/21_3_0"; })

            (mkApps { drv = graalvm17-ce-21_2_0; ns = "17/glibc/21_2_0"; })
            (mkApps { drv = graalvm17-ce; ns = "17/glibc/21_3_0"; })

            (mkApps { drv = graalvm17-ce-musl-21_2_0; ns = "17/musl/21_2_0"; })
            (mkApps { drv = graalvm17-ce-musl; ns = "17/musl/21_3_0"; })
          ];

        defaultApp = self.apps.${system}."11/glibc/latest/native-image";

        devShell = import ./shell.nix { inherit pkgs; };
      }
    );
}
