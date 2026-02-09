# ROBOT: OBO Tool for OWL reasoning, merging, diffing, converting.
# Wraps the official JAR from https://github.com/ontodev/robot/releases
{ pkgs, lib, stdenv, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "robot";
  version = "1.9.8";

  src = pkgs.fetchurl {
    url = "https://github.com/ontodev/robot/releases/download/v${version}/robot.jar";
    sha256 = "1y05bxffrmwnk59wdwyadfvgyblmg9h5730nba56s56qjc18nlbg";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/java $out/bin
    cp $src $out/share/java/robot.jar
    makeWrapper ${pkgs.jdk17}/bin/java $out/bin/robot \
      --add-flags "-jar $out/share/java/robot.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "ROBOT: OBO Tool for ontology development (OWL reasoning, merge, diff, convert)";
    homepage = "https://github.com/ontodev/robot";
    license = licenses.bsd3;
    mainProgram = "robot";
    platforms = platforms.unix;
  };
}
