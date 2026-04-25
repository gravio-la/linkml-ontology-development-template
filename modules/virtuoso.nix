# NixOS module: OpenLink Virtuoso triple store (via OCI container).
# Uses the official Docker image when Virtuoso is not available in nixpkgs.
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.virtuoso = {
    enable = lib.mkEnableOption "OpenLink Virtuoso triple store";

    httpPort = lib.mkOption {
      type = lib.types.port;
      default = 8890;
      description = "Virtuoso HTTP/SPARQL port";
    };

    sqlPort = lib.mkOption {
      type = lib.types.port;
      default = 1111;
      description = "Virtuoso SQL port (isql administration)";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/virtuoso";
      description = "Data directory (mounted into container)";
    };

    numberOfBuffers = lib.mkOption {
      type = lib.types.int;
      default = 170000;
      description = "Number of buffers (~2GB RAM when 8k pages)";
    };

    maxDirtyBuffers = lib.mkOption {
      type = lib.types.int;
      default = 130000;
      description = "Max dirty buffers";
    };

    defaultGraph = lib.mkOption {
      type = lib.types.str;
      default = "http://example.org/default";
      description = "Default graph IRI";
    };

    sparqlUpdateEnabled = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable SPARQL UPDATE";
    };

    corsEnabled = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow browser-based SPARQL (CORS)";
    };

    adminPassword = lib.mkOption {
      type = lib.types.str;
      default = "dba";
      description = "DBA password (change in production!)";
    };

    sparqlAuthRequired = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Require auth for SPARQL (enable in production)";
    };
  };

  config = lib.mkIf config.services.ontology-infra.virtuoso.enable {
    virtualisation.podman.enable = true;
    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers.virtuoso = {
      image = "openlink/virtuoso-opensource-7:latest";
      ports = [
        "${toString config.services.ontology-infra.virtuoso.httpPort}:8890"
        "${toString config.services.ontology-infra.virtuoso.sqlPort}:1111"
      ];
      volumes = [
        "${config.services.ontology-infra.virtuoso.dataDir}:/database"
      ];
      environment = {
        DBA_PASSWORD = config.services.ontology-infra.virtuoso.adminPassword;
        SPARQL_UPDATE = if config.services.ontology-infra.virtuoso.sparqlUpdateEnabled then "true" else "false";
        VIRTUOSO_SPARQL_CORS = if config.services.ontology-infra.virtuoso.corsEnabled then "1" else "0";
      };
      extraOptions = [ "--user=root" ];
    };

    systemd.tmpfiles.rules = [
      "d ${config.services.ontology-infra.virtuoso.dataDir} 0755 root root -"
    ];
  };
}
