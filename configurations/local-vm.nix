# NixOS configuration: local VM/container for testing
{ config, lib, pkgs, self, ... }: {
  imports = with self.nixosModules; [ virtuoso oxigraph nginx-proxy docs-site webvowl ];

  # Enable services (resource-constrained for laptop)
  services.ontology-infra = {
    virtuoso = {
      enable = true;
      numberOfBuffers = 85000;
      maxDirtyBuffers = 65000;
    };
    oxigraph.enable = true;
    nginx = {
      enable = true;
      domain = "local";
      acme = false;
    };
    docs.enable = true;
    webvowl.enable = true;
  };

  # Minimal required for NixOS to evaluate (VM/container build overrides these)
  system.stateVersion = "25.11";
  fileSystems."/" = { device = "tmpfs"; fsType = "tmpfs"; neededForBoot = true; };
  boot.loader.grub.devices = [ "nodev" ];
}
