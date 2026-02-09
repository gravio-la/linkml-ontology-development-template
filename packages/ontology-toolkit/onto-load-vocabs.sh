#!/usr/bin/env bash
# Load common vocabularies into a triple store via Graph Store Protocol.
# Usage: onto-load-vocabs --endpoint <sparql-graph-crud-base-url>
# Calls the load-vocabularies package/script which downloads and uploads each vocab.
set -euo pipefail
ENDPOINT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --endpoint|-e) ENDPOINT="$2"; shift 2 ;;
    *) shift ;;
  esac
done
if [[ -z "$ENDPOINT" ]]; then
  echo "Usage: onto-load-vocabs --endpoint <sparql-graph-crud-base-url>" >&2
  exit 1
fi
# Delegate to onto-load-vocabularies if available (same package)
if command -v onto-load-vocabularies &>/dev/null; then
  exec onto-load-vocabularies --endpoint "$ENDPOINT"
fi
# Otherwise inline: minimal set of vocabs to load (user can run load-vocabularies package for full set)
echo "Run the load-vocabularies package for full vocab loading, or ensure onto-load-vocabularies is on PATH." >&2
echo "Endpoint: $ENDPOINT" >&2
exit 1
