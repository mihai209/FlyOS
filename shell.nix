{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.pkgsCross.i686-embedded.buildPackages.gcc
    pkgs.pkgsCross.i686-embedded.buildPackages.binutils
    pkgs.nasm
    pkgs.qemu
    pkgs.cdrtools
  ];
}
