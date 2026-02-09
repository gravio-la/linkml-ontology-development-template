# NixOS configuration: production Contabo VPS (stub — implemented in Phase 5b)
{ config, lib, pkgs, self, ... }: {
  imports = with self.nixosModules; [
    virtuoso oxigraph nginx-proxy graviola webvowl docs-site
  ];
  # Placeholder: no services enabled until Phase 5b
}
