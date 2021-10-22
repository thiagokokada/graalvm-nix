#!/usr/bin/env nix-shell
#!nix-shell -p coreutils gnused nixUnstable nixpkgs-fmt -i bash

set -euo pipefail

readonly file="bin-names.nix"

nix build --experimental-features 'nix-command flakes' .
echo "# Generated by $(basename $0) script" > "$file"
echo "[" >> "$file"
echo 'result/bin/'* | sed 's|result/bin/||g' | sed 's|[^ ][^ ]*|"&"|g' >> "$file"
echo "]" >> "$file"
nixpkgs-fmt "$file"