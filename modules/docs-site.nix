# NixOS module: static ontology documentation site (stub — implemented in Phase 4d)
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.docs = {
    enable = lib.mkEnableOption "static ontology documentation site";
  };
  config = lib.mkIf config.services.ontology-infra.docs.enable { };
}
