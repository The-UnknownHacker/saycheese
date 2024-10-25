{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    pkgs.gcc  
    pkgs.nasm
    pkgs.qrencode
  ];
}