# Ontology project Makefile — generate, validate, deploy, document
SCHEMA ?= src/schema.yaml
OUTDIR ?= generated
DOCSDIR ?= docs
ENDPOINT ?= http://localhost:8890/sparql-graph-crud

.PHONY: generate validate deploy document serve-docs clean all

generate:
	onto-generate $(SCHEMA) --output-dir $(OUTDIR)

validate: generate
	./tests/validate.sh $(SCHEMA) data/sample-instances.ttl $(OUTDIR)

deploy: generate
	@echo "Deploying ontology and shapes to $(ENDPOINT) ..."
	onto-deploy $(OUTDIR)/owl/$$(basename $(SCHEMA) .yaml).owl.ttl --endpoint $(ENDPOINT) --graph https://example.org/my-ontology/
	onto-deploy $(OUTDIR)/shacl/$$(basename $(SCHEMA) .yaml).shacl.ttl --endpoint $(ENDPOINT) --graph https://example.org/my-ontology/shacl

document: generate
	onto-document $(OUTDIR)/owl/$$(basename $(SCHEMA) .yaml).owl.ttl --output-dir $(DOCSDIR) --format pylode

serve-docs: document
	python -m http.server 8080 --directory $(DOCSDIR) &
	@echo "Docs at http://localhost:8080 — Ctrl+C to stop"
	@wait

clean:
	rm -rf $(OUTDIR) $(DOCSDIR)

all: generate validate document
