# Load common vocabularies into a triple store via Graph Store Protocol.
{ pkgs, lib, stdenv, makeWrapper }:

stdenv.mkDerivation {
  pname = "load-vocabularies";
  version = "0.1.0";
  src = ./load-vocabularies.sh;
  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 $src $out/bin/onto-load-vocabularies
    wrapProgram $out/bin/onto-load-vocabularies \
      --prefix PATH : ${lib.makeBinPath [ pkgs.curl pkgs.librdf_raptor2 ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Download and load schema.org, DC, SKOS, PROV-O, FOAF, ORG, SHACL into a triple store";
    homepage = "https://github.com/bastiion/ontology-infra";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "onto-load-vocabularies";
  };
}
