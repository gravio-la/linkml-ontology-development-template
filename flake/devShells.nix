# Dev shell definitions: ontology, frontend, python, default (merged).
{ config, pkgs, ... }: {
  perSystem = { pkgs, system, config, ... }: let
    # Copy requirements into store so the shell works regardless of flake source layout
    reqFile = pkgs.runCommand "ontology-requirements.txt" { src = ../requirements/ontology-requirements.txt; } "cp $src $out";
    pythonWithNix = pkgs.python312.withPackages (ps: with ps; [
      pyyaml jsonschema requests click
      rdflib sparqlwrapper
    ]);
    ontologyBaseInputs = with pkgs; [
      pythonWithNix
      apache-jena
      librdf_raptor2
      config.packages.robot
      config.packages.widoco
      curl jq yq-go git
      nodejs_22
    ];
    ontologyShellHook = ''
      export ONTOLOGY_REQUIREMENTS="${reqFile}"
      if [ -n "''${ONTOLOGY_REQUIREMENTS:-}" ] && [ -f "$ONTOLOGY_REQUIREMENTS" ]; then
        if [ ! -d .venv ]; then
          echo "Creating .venv and installing ontology requirements..."
          ${pkgs.python312}/bin/python -m venv .venv
          .venv/bin/pip install --upgrade pip
          .venv/bin/pip install -r "$ONTOLOGY_REQUIREMENTS"
        fi
        export PATH="$(pwd)/.venv/bin:$PATH"
      fi
      echo "Ontology shell: linkml, pyshacl, robot, widoco, jena (riot, arq, shacl), rapper available."
    '';
  in {
    devShells.ontology = pkgs.mkShell {
      name = "ontology-infra-ontology";
      nativeBuildInputs = ontologyBaseInputs;
      shellHook = ontologyShellHook;
      meta.description = "Ontology engineering: LinkML, pyshacl, ROBOT, WIDOCO, Jena, rapper, Node.js";
    };

    devShells.frontend = pkgs.mkShell {
      name = "ontology-infra-frontend";
      nativeBuildInputs = with pkgs; [ bun nodejs_22 turbo ];
      meta.description = "Frontend: Bun, Node.js 22, Turborepo (Graviola)";
    };

    devShells.python = pkgs.mkShell {
      name = "ontology-infra-python";
      nativeBuildInputs = with pkgs; [
        pythonWithNix
        librdf_raptor2
        curl jq yq-go git
      ];
      shellHook = ontologyShellHook;
      meta.description = "Light Python RDF shell: rdflib, pyshacl, linkml via venv, rapper, curl/jq/yq";
    };

    devShells.default = pkgs.mkShell {
      name = "ontology-infra-default";
      nativeBuildInputs = ontologyBaseInputs ++ (with pkgs; [ bun turbo ]);
      shellHook = ontologyShellHook + ''
        echo "Default shell: ontology + frontend (bun, turbo)."
      '';
      meta.description = "Combined ontology + frontend dev shell";
    };
  };
}
