{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        defaultPackage = let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.mkShell {
          buildInputs = [
            pkgs.gcc  
            pkgs.nasm
            pkgs.qrencode
          ];
        };
      }
    );
}