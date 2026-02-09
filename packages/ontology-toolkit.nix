# Ontology toolkit: wrapper scripts for generate, validate, deploy, document, load-vocabs.
# Run from the ontology dev shell so linkml, pyshacl, pylode, curl are on PATH.
{ pkgs, lib, stdenv }:

stdenv.mkDerivation {
  pname = "ontology-toolkit";
  version = "0.1.0";
  src = ./ontology-toolkit;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    for f in onto-*.sh; do
      install -Dm755 "$f" "$out/bin/''${f%.sh}"
    done
    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI scripts: onto-generate, onto-validate, onto-deploy, onto-document, onto-load-vocabs";
    homepage = "https://github.com/bastiion/ontology-infra";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "onto-generate";
  };
}
