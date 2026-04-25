# NixOS module: WebVOWL ontology visualization (static site).
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.webvowl = {
    enable = lib.mkEnableOption "WebVOWL ontology visualization";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8081;
      description = "Port to serve WebVOWL on";
    };

    root = lib.mkOption {
      type = lib.types.str;
      default = "/var/www/webvowl";
      description = "Directory containing WebVOWL static files";
    };
  };

  config = lib.mkIf config.services.ontology-infra.webvowl.enable {
    systemd.services.webvowl = {
      description = "WebVOWL ontology visualization";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { Restart = "on-failure"; };
      script = ''
        exec ${pkgs.darkhttpd}/bin/darkhttpd ${config.services.ontology-infra.webvowl.root} \
          --port ${toString config.services.ontology-infra.webvowl.port} \
          --addr 127.0.0.1
      '';
    };
    systemd.tmpfiles.rules = [
      "d ${config.services.ontology-infra.webvowl.root} 0755 root root -"
    ];
  };
}
