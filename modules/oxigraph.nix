# NixOS module: Oxigraph SPARQL store (stub — implemented in Phase 4b)
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.oxigraph = {
    enable = lib.mkEnableOption "Oxigraph SPARQL store";
  };
  config = lib.mkIf config.services.ontology-infra.oxigraph.enable { };
}
