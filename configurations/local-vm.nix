# NixOS configuration: local VM/container for testing (stub — implemented in Phase 5a)
{ config, lib, pkgs, self, ... }: {
  imports = with self.nixosModules; [ virtuoso oxigraph nginx-proxy docs-site webvowl ];
  # Placeholder: no services enabled until Phase 5a
}
