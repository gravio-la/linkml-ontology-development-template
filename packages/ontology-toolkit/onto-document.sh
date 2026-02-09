#!/usr/bin/env bash
# Generate HTML documentation from an ontology (pylode or widoco).
# Usage: onto-document <ontology.owl.ttl> [--output-dir ./docs] [--format pylode|widoco]
set -euo pipefail
ONTOLOGY=""
OUTDIR="./docs"
FORMAT="pylode"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output-dir|-o) OUTDIR="$2"; shift 2 ;;
    --format|-f) FORMAT="$2"; shift 2 ;;
    *) ONTOLOGY="$1"; shift ;;
  esac
done
if [[ -z "$ONTOLOGY" || ! -f "$ONTOLOGY" ]]; then
  echo "Usage: onto-document <ontology.owl.ttl> [--output-dir ./docs] [--format pylode|widoco]" >&2
  exit 1
fi
mkdir -p "$OUTDIR"
case "$FORMAT" in
  pylode)
    pylode "$ONTOLOGY" -o "$OUTDIR" 2>/dev/null || pylode "$ONTOLOGY" > "$OUTDIR/index.html"
    echo "Documentation (pylode) in $OUTDIR"
    ;;
  widoco)
    widoco -ontFile "$ONTOLOGY" -outFolder "$OUTDIR" -rewriteAll 2>/dev/null || widoco -ontFile "$ONTOLOGY" -outFolder "$OUTDIR"
    echo "Documentation (widoco) in $OUTDIR"
    ;;
  *)
    echo "Unknown format: $FORMAT (use pylode or widoco)" >&2
    exit 1
    ;;
esac
