# NixOS module: Graviola framework demo (static bundle).
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.graviola = {
    enable = lib.mkEnableOption "Graviola framework demo instance";

    port = lib.mkOption {
      type = lib.types.port;
      default = 5173;
      description = "Port to serve the app on";
    };

    root = lib.mkOption {
      type = lib.types.str;
      default = "/var/www/graviola";
      description = "Directory containing pre-built Graviola static files";
    };

    sparqlEndpoint = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:8890/sparql";
      description = "SPARQL endpoint URL (for app config)";
    };
  };

  config = lib.mkIf config.services.ontology-infra.graviola.enable {
    systemd.services.graviola = {
      description = "Graviola CRUD framework demo";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { Restart = "on-failure"; };
      script = ''
        exec ${pkgs.darkhttpd}/bin/darkhttpd ${config.services.ontology-infra.graviola.root} \
          --port ${toString config.services.ontology-infra.graviola.port} \
          --addr 127.0.0.1
      '';
    };
    systemd.tmpfiles.rules = [
      "d ${config.services.ontology-infra.graviola.root} 0755 root root -"
    ];
  };
}
