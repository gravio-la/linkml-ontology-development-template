# WIDOCO: Wizard for DOCumenting Ontologies.
# Wraps the official JAR from https://github.com/dgarijo/Widoco/releases
{ pkgs, lib, stdenv, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "widoco";
  version = "1.4.24";

  src = pkgs.fetchurl {
    url = "https://github.com/dgarijo/Widoco/releases/download/v${version}/widoco-${version}-jar-with-dependencies_JDK-17.jar";
    sha256 = "0kilcgyaf27hx5a1xkd3ca5x3vrsrcgg0nm5jjnyf6nm5j6l1iyi";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/java $out/bin
    cp $src $out/share/java/widoco.jar
    makeWrapper ${pkgs.jdk17}/bin/java $out/bin/widoco \
      --add-flags "-jar $out/share/java/widoco.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "WIDOCO: Wizard for DOCumenting Ontologies (HTML documentation from OWL)";
    homepage = "https://github.com/dgarijo/Widoco";
    license = licenses.asl20;
    mainProgram = "widoco";
    platforms = platforms.unix;
  };
}
