# NixOS configuration: production Contabo VPS
{ config, lib, pkgs, self, ... }: {
  imports = with self.nixosModules; [
    virtuoso oxigraph nginx-proxy graviola webvowl docs-site
  ];

  # Enable full stack
  services.ontology-infra = {
    virtuoso = {
      enable = true;
      sparqlAuthRequired = true;
    };
    oxigraph.enable = true;
    nginx = {
      enable = true;
      acme = true;
    };
    graviola.enable = true;
    webvowl.enable = true;
    docs.enable = true;
  };

  # Firewall: only 22, 80, 443
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  # Fail2ban for SSH (sshd jail is enabled by default)
  services.fail2ban.enable = true;

  # Daily backup of triple store data (placeholder: adjust paths and backup target)
  systemd.timers.ontology-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "daily";
  };
  systemd.services.ontology-backup = {
    description = "Backup Virtuoso and Oxigraph data";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /var/backups/ontology-infra
      tar -czf /var/backups/ontology-infra/virtuoso-$(date +%Y%m%d).tar.gz -C /var/lib virtuoso 2>/dev/null || true
      tar -czf /var/backups/ontology-infra/oxigraph-$(date +%Y%m%d).tar.gz -C /var/lib oxigraph 2>/dev/null || true
    '';
  };

  # Minimal required for NixOS to evaluate (real deployment overrides these)
  system.stateVersion = "25.11";
  fileSystems."/" = { device = "tmpfs"; fsType = "tmpfs"; neededForBoot = true; };
  boot.loader.grub.devices = [ "nodev" ];
}
