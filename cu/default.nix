{ pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  name = "cu-openbsd";
  src = ./.;

  buildInputs = with pkgs; [ libevent libbsd ];

  buildPhase = ''
    for file in *.c; do cc -c $file -o $file.o; done
    cc -levent -lbsd *.o -o cu
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp cu.1 $out/share/man/man1/cu.1
    gzip $out/share/man/man1/cu.1
    install cu $out/bin/cu
  '';
}
