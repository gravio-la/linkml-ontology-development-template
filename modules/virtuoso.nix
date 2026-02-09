# NixOS module: OpenLink Virtuoso triple store (stub — implemented in Phase 4a)
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.virtuoso = {
    enable = lib.mkEnableOption "OpenLink Virtuoso triple store";
  };
  config = lib.mkIf config.services.ontology-infra.virtuoso.enable { };
}
