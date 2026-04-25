# Ontology Development Template

This project uses LinkML for schema definition and generates OWL, SHACL, JSON Schema, and documentation.

## Quick start

```bash
nix develop   # drops into dev shell with linkml, pyshacl, robot, etc.
make generate
make validate
make document
```

## Layout

- `src/schema.yaml` — LinkML schema (edit for your domain)
- `data/` — sample RDF (`.ttl`) and JSON-LD data
- `queries/` — SPARQL competency questions
- `generated/` — produced by `make generate` (owl, shacl, json, docs)
- `tests/validate.sh` — SHACL validation script

## Targets

| Target        | Description                          |
|---------------|--------------------------------------|
| `make generate` | Run LinkML generators (OWL, SHACL, JSON Schema, docs) |
| `make validate` | Validate sample data against SHACL   |
| `make deploy`   | Upload ontology/shapes to triple store (set `ENDPOINT`) |
| `make document` | Generate HTML documentation (pylode) |
| `make serve-docs` | Serve docs at http://localhost:8080 |
| `make clean`   | Remove generated artifacts          |
| `make all`     | generate + validate + document       |

## Deploy to local Virtuoso

```bash
make deploy ENDPOINT=http://localhost:8890/sparql-graph-crud
```

## SPARQL queries

```bash
arq --data generated/owl/*.ttl --data data/sample-instances.ttl --query queries/competency-questions.rq
```
