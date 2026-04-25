# NixOS module: static ontology documentation site (served via darkhttpd).
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.docs = {
    enable = lib.mkEnableOption "static ontology documentation site";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port to serve the docs on";
    };

    root = lib.mkOption {
      type = lib.types.str;
      default = "/var/www/ontology-docs";
      description = "Directory to serve (deployed by CI or onto-document)";
    };
  };

  config = lib.mkIf config.services.ontology-infra.docs.enable {
    systemd.services.ontology-docs = {
      description = "Ontology documentation static site";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { Restart = "on-failure"; };
      script = ''
        exec ${pkgs.darkhttpd}/bin/darkhttpd ${config.services.ontology-infra.docs.root} \
          --port ${toString config.services.ontology-infra.docs.port} \
          --addr 127.0.0.1
      '';
    };
    systemd.tmpfiles.rules = [
      "d ${config.services.ontology-infra.docs.root} 0755 root root -"
    ];
  };
}
