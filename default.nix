{ pkgs ? import <nixpkgs> {}}:
{
  cu = pkgs.callPackage ./cu {};
  hardening-check = pkgs.callPackage ./hardening-check {};
}
