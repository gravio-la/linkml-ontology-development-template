#!/usr/bin/env bash
# Deploy ontology to a triple store via SPARQL Graph Store Protocol (HTTP PUT).
# Usage: onto-deploy <ontology.ttl> --endpoint <sparql-graph-crud-url> --graph <named-graph-iri>
set -euo pipefail
FILE=""
ENDPOINT=""
GRAPH=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --endpoint|-e) ENDPOINT="$2"; shift 2 ;;
    --graph|-g) GRAPH="$2"; shift 2 ;;
    *) FILE="$1"; shift ;;
  esac
done
if [[ -z "$FILE" || ! -f "$FILE" ]] || [[ -z "$ENDPOINT" ]]; then
  echo "Usage: onto-deploy <ontology.ttl> --endpoint <sparql-graph-crud-url> [--graph <named-graph-iri>]" >&2
  exit 1
fi
# Graph Store Protocol: PUT to .../store?graph=<iri> or .../store (default graph)
if [[ -n "$GRAPH" ]]; then
  URL="${ENDPOINT}?graph=${GRAPH}"
else
  URL="$ENDPOINT"
fi
curl -sS -X PUT -H "Content-Type: text/turtle" --data-binary @"$FILE" "$URL" || { echo "Deploy failed." >&2; exit 1; }
echo "Deployed $FILE to $URL"
