# NixOS module: nginx reverse proxy (stub — implemented in Phase 4c)
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.nginx = {
    enable = lib.mkEnableOption "nginx reverse proxy for ontology services";
  };
  config = lib.mkIf config.services.ontology-infra.nginx.enable { };
}
