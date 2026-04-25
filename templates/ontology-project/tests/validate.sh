#!/usr/bin/env bash
# Validate sample data against SHACL shapes.
# Run from project root: ./tests/validate.sh
set -euo pipefail
SCHEMA="${1:-src/schema.yaml}"
DATA="${2:-data/sample-instances.ttl}"
OUTDIR="${3:-generated}"
SHAPES="${OUTDIR}/shacl/$(basename "$SCHEMA" .yaml).shacl.ttl"
if [[ ! -f "$SHAPES" ]]; then
  echo "Run 'make generate' first to produce $SHAPES"
  exit 1
fi
if [[ ! -f "$DATA" ]]; then
  echo "Data file not found: $DATA"
  exit 1
fi
echo "Validating $DATA against $SHAPES ..."
pyshacl -s "$SHAPES" "$DATA" --ont-graph "${OUTDIR}/owl/$(basename "$SCHEMA" .yaml).owl.ttl" && echo "Validation passed."
