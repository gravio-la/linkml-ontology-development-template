# NixOS module: WebVOWL ontology visualization (stub — implemented in Phase 4d)
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.webvowl = {
    enable = lib.mkEnableOption "WebVOWL ontology visualization";
  };
  config = lib.mkIf config.services.ontology-infra.webvowl.enable { };
}
