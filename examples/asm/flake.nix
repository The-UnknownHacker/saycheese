{
  name = "saycheese";
  description = "2048 game inside a QR code.";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devShells.default = import ./shell.nix { inherit pkgs; };
        }
      );
}