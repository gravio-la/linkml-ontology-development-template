#!/usr/bin/env bash
# Download common vocabularies and load them into a triple store via Graph Store Protocol.
# Usage: onto-load-vocabularies --endpoint <base-url>
# Example: --endpoint http://localhost:8890/sparql-graph-crud
set -euo pipefail
ENDPOINT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --endpoint|-e) ENDPOINT="$2"; shift 2 ;;
    *) shift ;;
  esac
done
if [[ -z "$ENDPOINT" ]]; then
  echo "Usage: onto-load-vocabularies --endpoint <sparql-graph-crud-base-url>" >&2
  exit 1
fi
# Ensure URL has no trailing slash for appending ?graph=
BASE="${ENDPOINT%/}"
CURL_OPTS=(-sS -X PUT -H "Content-Type: text/turtle")

put_graph() {
  local graph_iri="$1"
  local url="$2"
  local file="$3"
  if [[ -f "$file" ]]; then
    echo "Loading $graph_iri ..."
    curl "${CURL_OPTS[@]}" --data-binary @"$file" "${BASE}?graph=${graph_iri}" || true
  fi
}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cd "$TMP"

# Download vocabularies (common URLs; may need adjustment for redirects)
curl -sSL -o schema.ttl "https://schema.org/version/latest/schemaorg-current-https.ttl" 2>/dev/null && put_graph "http://schema.org/" "$BASE" schema.ttl
curl -sSL -o dcterms.ttl "https://www.dublincore.org/specifications/dublin-core/dcmi-terms/dublin_core_terms.ttl" 2>/dev/null && put_graph "http://purl.org/dc/terms/" "$BASE" dcterms.ttl
curl -sSL -o dce.ttl "https://www.dublincore.org/specifications/dublin-core/dcmi-terms/dublin_core_elements.ttl" 2>/dev/null && put_graph "http://purl.org/dc/elements/1.1/" "$BASE" dce.ttl
curl -sSL -o skos.ttl "https://www.w3.org/2009/08/skos-reference/skos.rdf" 2>/dev/null && { rapper -i rdfxml -o turtle skos.ttl 2>/dev/null > skos_t.ttl && put_graph "http://www.w3.org/2004/02/skos/core" "$BASE" skos_t.ttl; } || put_graph "http://www.w3.org/2004/02/skos/core" "$BASE" skos.ttl
curl -sSL -o prov.ttl "https://www.w3.org/ns/prov-o" 2>/dev/null && put_graph "http://www.w3.org/ns/prov" "$BASE" prov.ttl
curl -sSL -o foaf.ttl "https://xmlns.com/foaf/spec/20140114.rdf" 2>/dev/null && { rapper -i rdfxml -o turtle foaf.ttl 2>/dev/null > foaf_t.ttl && put_graph "http://xmlns.com/foaf/0.1/" "$BASE" foaf_t.ttl; } || put_graph "http://xmlns.com/foaf/0.1/" "$BASE" foaf.ttl
curl -sSL -o org.ttl "https://www.w3.org/ns/org.ttl" 2>/dev/null && put_graph "http://www.w3.org/ns/org#" "$BASE" org.ttl
curl -sSL -o shacl.ttl "https://www.w3.org/ns/shacl.ttl" 2>/dev/null && put_graph "http://www.w3.org/ns/shacl" "$BASE" shacl.ttl

echo "Vocabulary loading finished."
