# NixOS module: nginx reverse proxy for ontology services.
# Creates virtualHosts based on which services are enabled.
{ config, lib, pkgs, ... }: {
  options.services.ontology-infra.nginx = {
    enable = lib.mkEnableOption "nginx reverse proxy for ontology services";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "ontology.example.com";
      description = "Base domain; subdomains sparql, oxigraph, docs, vowl, app will be used";
    };

    acme = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Let's Encrypt HTTPS (set true for production)";
    };
  };

  config = lib.mkIf config.services.ontology-infra.nginx.enable (let
    cfg = config.services.ontology-infra.nginx;
    base = cfg.domain;
    proxyVhost = subdomain: port: {
      "${subdomain}.${base}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
        enableACME = cfg.acme;
        forceSSL = cfg.acme;
      };
    };
    virtuosoEnabled = config.services.ontology-infra.virtuoso.enable or false;
    oxigraphEnabled = config.services.ontology-infra.oxigraph.enable or false;
    docsEnabled = config.services.ontology-infra.docs.enable or false;
    webvowlEnabled = config.services.ontology-infra.webvowl.enable or false;
    graviolaEnabled = config.services.ontology-infra.graviola.enable or false;
    virtuosoPort = config.services.ontology-infra.virtuoso.httpPort or 8890;
    oxigraphPort = config.services.ontology-infra.oxigraph.port or 7878;
    docsPort = config.services.ontology-infra.docs.port or 8080;
    webvowlPort = config.services.ontology-infra.webvowl.port or 8081;
    graviolaPort = config.services.ontology-infra.graviola.port or 5173;
  in {
    services.nginx = {
      enable = true;
      virtualHosts =
        (lib.optionalAttrs virtuosoEnabled (proxyVhost "sparql" virtuosoPort))
        // (lib.optionalAttrs oxigraphEnabled (proxyVhost "oxigraph" oxigraphPort))
        // (lib.optionalAttrs docsEnabled (proxyVhost "docs" docsPort))
        // (lib.optionalAttrs webvowlEnabled (proxyVhost "vowl" webvowlPort))
        // (lib.optionalAttrs graviolaEnabled (proxyVhost "app" graviolaPort));
    };
    security.acme.acceptTerms = lib.mkDefault cfg.acme;
    security.acme.defaults.email = lib.mkIf cfg.acme (lib.mkDefault "admin@${base}");
  });
}
