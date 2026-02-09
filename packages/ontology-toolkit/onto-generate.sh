#!/usr/bin/env bash
# Generate all artifacts from a LinkML schema (OWL, SHACL, JSON Schema, JSON-LD context, Pydantic, doc).
# Usage: onto-generate <schema.yaml> [--output-dir ./generated]
set -euo pipefail
SCHEMA=""
OUTDIR="./generated"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output-dir) OUTDIR="$2"; shift 2 ;;
    -o) OUTDIR="$2"; shift 2 ;;
    *) SCHEMA="$1"; shift ;;
  esac
done
if [[ -z "$SCHEMA" || ! -f "$SCHEMA" ]]; then
  echo "Usage: onto-generate <schema.yaml> [--output-dir ./generated]" >&2
  exit 1
fi
mkdir -p "$OUTDIR/owl" "$OUTDIR/shacl" "$OUTDIR/json" "$OUTDIR/docs"
BASE=$(basename "$SCHEMA" .yaml)
# LinkML generators (require: pip install linkml)
gen-owl "$SCHEMA" -o "$OUTDIR/owl/${BASE}.owl.ttl" 2>/dev/null || gen-owl "$SCHEMA" > "$OUTDIR/owl/${BASE}.owl.ttl"
gen-shacl "$SCHEMA" -o "$OUTDIR/shacl/${BASE}.shacl.ttl" 2>/dev/null || gen-shacl "$SCHEMA" > "$OUTDIR/shacl/${BASE}.shacl.ttl"
gen-json-schema "$SCHEMA" -o "$OUTDIR/json/${BASE}.schema.json" 2>/dev/null || true
gen-jsonld-context "$SCHEMA" -o "$OUTDIR/json/${BASE}.context.jsonld" 2>/dev/null || true
gen-pydantic "$SCHEMA" -o "$OUTDIR/json/${BASE}_model.py" 2>/dev/null || true
gen-doc "$SCHEMA" -d "$OUTDIR/docs" 2>/dev/null || true
echo "Generated in $OUTDIR"
