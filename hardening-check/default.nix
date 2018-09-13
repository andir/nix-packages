{ stdenv, callPackage, perlPackages, binutils-unwrapped, glibc, makeWrapper, perl, runCommand, coreutils }:
let
  src = callPackage ./repo.nix {};

  binaryPath = stdenv.lib.makeBinPath [ binutils-unwrapped glibc.bin ];

  hardening-test-raw = stdenv.mkDerivation {
    name = "hardening-test-unpatched";
    inherit src;

    buildInputs = with perlPackages; [ TermANSIColor IPCRun3 PodUsage GetoptLong ] ++
                  [ makeWrapper perl ];

    buildPhase = ''
      mkdir bin
      cp hardening-wrapper/hardening-check bin
      chmod +x bin/hardening-check
      patchShebangs bin/hardening-check
    '';

    postFixup = ''
      wrapProgram $out/bin/hardening-check \
          --prefix PERL5LIB : "$PERL5LIB" \
          --prefix PATH : "${binaryPath}"
    '';

    installPhase = ''
      mkdir  $out
      cp -avr bin $out/bin
    '';
  };
in hardening-test-raw.overrideAttrs (old: {
  name = "hardening-test";
  nativeBuildInputs = [ hardening-test-raw ];
  buildInputs = [ makeWrapper perl ];
  preFixup = ''
    LIBC_FUNCS=$(hardening-check --find-libc-functions ${coreutils}/bin/ls)
    perl -pi -e "s/^my %libc;/my %libc = (\n$LIBC_FUNCS\n);/;" $out/bin/hardening-check
  '';
})
