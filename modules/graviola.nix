# NixOS module: Graviola framework demo (stub — implemented in Phase 4d)
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.graviola = {
    enable = lib.mkEnableOption "Graviola framework demo instance";
  };
  config = lib.mkIf config.services.ontology-infra.graviola.enable { };
}
