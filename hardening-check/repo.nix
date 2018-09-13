# this checks out the sources from the debian SCM dump
{ fetchzip, bazaar, gnutar }:
let
  sources = fetchzip {
    name = "debian-hardening";
    url = https://alioth-archive.debian.org/bzr/hardening.tar.xz;
    sha256 = "1w80hzz6h4gvw638p43mhfv8369j7iidspbj39d65q63512g0zjq";
    postFetch = ''
      tar xf $downloadedFile
      ${bazaar}/bin/bzr init checkout
      cd checkout
      ${bazaar}/bin/bzr branch ../hardening/master
      cp -avr master $out
    '';
  };
in sources
