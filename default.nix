{ pkgs ? import <nixpkgs> {}}:
{
  cu = pkgs.callPackage ./cu {};
}
