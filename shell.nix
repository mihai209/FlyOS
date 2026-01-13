{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.nasm
    pkgs.qemu
    pkgs.binutils
    pkgs.gnumake
  ];
}
