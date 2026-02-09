#!/usr/bin/env bash
# Validate data against SHACL shapes (uses pyshacl).
# Usage: onto-validate <data.ttl> --shapes <shapes.ttl> [--ontology <ontology.owl.ttl>]
set -euo pipefail
DATA=""
SHAPES=""
ONTOLOGY=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --shapes) SHAPES="$2"; shift 2 ;;
    -s) SHAPES="$2"; shift 2 ;;
    --ontology|-o) ONTOLOGY="$2"; shift 2 ;;
    *) DATA="$1"; shift ;;
  esac
done
if [[ -z "$DATA" || ! -f "$DATA" ]] || [[ -z "$SHAPES" || ! -f "$SHAPES" ]]; then
  echo "Usage: onto-validate <data.ttl> --shapes <shapes.ttl> [--ontology <ontology.owl.ttl>]" >&2
  exit 1
fi
EXTRA=()
if [[ -n "$ONTOLOGY" && -f "$ONTOLOGY" ]]; then
  EXTRA=(--ont-graph "$ONTOLOGY")
fi
pyshacl -s "$SHAPES" "$DATA" "${EXTRA[@]}" || { echo "Validation failed." >&2; exit 1; }
echo "Validation passed."
