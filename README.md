# Ontology Engineering Infrastructure (NixOS Flake)

Reproducible NixOS infrastructure for the full ontology engineering lifecycle: LinkML, SHACL, triple stores (Virtuoso, Oxigraph), documentation (pyLODE, WIDOCO), and the Graviola CRUD framework. Can be used as a template for new ontology projects.

## Quick start

```bash
# Enter the combined dev shell (ontology + frontend tools)
nix develop

# Or a specific shell
nix develop .#ontology    # LinkML, pyshacl, ROBOT, WIDOCO, Jena, rapper
nix develop .#frontend   # Bun, Node.js 22, Turbo
nix develop .#python     # Light Python RDF shell (no Java)
```

With [direnv](https://direnv.net/): run `direnv allow` in the repo; then `nix develop` runs automatically.

## Scaffold a new ontology project

```bash
nix flake init -t .#ontology-project
nix develop
# Edit src/schema.yaml, then:
make generate
make validate
make document
```

## Dev shells

| Shell       | Contents |
|------------|----------|
| `default`  | Ontology + frontend (everything) |
| `ontology` | Python 3.12 + venv (linkml, pyshacl, pylode, owlready2, ontospy), Apache Jena (riot, arq, shacl), rapper, ROBOT, WIDOCO, Node.js 22, curl/jq/yq |
| `frontend` | Bun, Node.js 22, Turbo (Graviola development) |
| `python`   | Light ontology shell: Python + venv, rapper, curl/jq/yq (no Java tools) |

On first enter, the ontology/python shells create a `.venv` and install pip requirements from `requirements/ontology-requirements.txt`.

## Packages

- **ontology-toolkit** — CLI: `onto-generate`, `onto-validate`, `onto-deploy`, `onto-document`, `onto-load-vocabs` (use from the ontology dev shell)
- **load-vocabularies** — `onto-load-vocabularies --endpoint <url>` to load schema.org, DC, SKOS, PROV-O, FOAF, ORG, SHACL into a store
- **robot** — ROBOT OBO Tool (OWL reasoning, merge, diff, convert)
- **widoco** — WIDOCO ontology documentation wizard

```bash
nix run .#ontology-toolkit -- onto-generate src/schema.yaml -o generated
nix run .#load-vocabularies -- --endpoint http://localhost:8890/sparql-graph-crud
```

## NixOS modules

Enable in your NixOS config or via the provided configurations:

| Module         | Service |
|----------------|---------|
| `virtuoso`     | OpenLink Virtuoso (OCI container), HTTP/SPARQL and SQL ports, dataDir, memory options |
| `oxigraph`     | Oxigraph SPARQL store (systemd), port and dataDir |
| `nginx-proxy`  | Nginx reverse proxy; virtualHosts for sparql, oxigraph, docs, vowl, app from enabled services |
| `graviola`     | Static Graviola demo (darkhttpd) |
| `webvowl`      | WebVOWL static site (darkhttpd) |
| `docs-site`    | Static ontology docs (darkhttpd) |

Options live under `services.ontology-infra.<name>` (e.g. `services.ontology-infra.virtuoso.httpPort`, `services.ontology-infra.nginx.acme`).

## Local VM / container testing

```bash
# Build and run the NixOS VM
nix run .#nixosConfigurations.local-vm.config.system.build.vm

# Or create a container
sudo nixos-container create ontology-lab --flake .#local-vm
sudo nixos-container start ontology-lab
```

The `local-vm` configuration enables Virtuoso (reduced memory), Oxigraph, nginx (HTTP, domain `*.local`), docs, and WebVOWL.

## Server deployment 

```bash
nixos-rebuild switch --flake .#remote-server --target-host root@<server-ip>
```

The `remote-server` configuration enables the full stack, HTTPS (ACME), firewall (22, 80, 443), Fail2ban, and a daily backup timer for triple store data.

## Ontology toolkit CLI reference

- **onto-generate** `<schema.yaml>` [--output-dir ./generated] — LinkML → OWL, SHACL, JSON Schema, JSON-LD context, Pydantic, docs
- **onto-validate** `<data.ttl>` --shapes `<shapes.ttl>` [--ontology `<ontology.owl.ttl>`] — pyshacl validation
- **onto-deploy** `<ontology.ttl>` --endpoint `<sparql-graph-crud-url>` [--graph `<graph-iri>`] — Graph Store PUT
- **onto-document** `<ontology.owl.ttl>` [--output-dir ./docs] [--format pylode|widoco] — HTML documentation
- **onto-load-vocabs** --endpoint `<sparql-graph-crud-base-url>` — Load common vocabularies into the store

## Flake outputs

- `devShells.default`, `devShells.ontology`, `devShells.frontend`, `devShells.python`
- `packages.ontology-toolkit`, `packages.load-vocabularies`, `packages.robot`, `packages.widoco`
- `nixosModules.virtuoso`, `oxigraph`, `nginx-proxy`, `graviola`, `webvowl`, `docs-site`
- `nixosConfigurations.local-vm`, `remote-server`
- `templates.ontology-project`
- `lib.mkOntologyProject`

## Requirements

- Nix with flakes (Nix 2.4+)
- Linux (NixOS or other distro for `nix develop`; NixOS for the VM/server configs)
