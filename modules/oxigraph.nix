# NixOS module: Oxigraph SPARQL store (Rust binary from nixpkgs).
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.oxigraph = {
    enable = lib.mkEnableOption "Oxigraph SPARQL store";

    port = lib.mkOption {
      type = lib.types.port;
      default = 7878;
      description = "HTTP port for /query, /update, /store";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/oxigraph";
      description = "Data directory";
    };

    bind = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Bind address";
    };
  };

  config = lib.mkIf config.services.ontology-infra.oxigraph.enable {
    systemd.services.oxigraph = {
      description = "Oxigraph SPARQL store";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "oxigraph";
        Restart = "on-failure";
      };
      script = ''
        exec ${pkgs.oxigraph}/bin/oxigraph serve \
          --location /var/lib/oxigraph \
          --bind ${config.services.ontology-infra.oxigraph.bind}:${toString config.services.ontology-infra.oxigraph.port}
      '';
    };
  };
}
