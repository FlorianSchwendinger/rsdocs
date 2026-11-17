#!/usr/bin/env bash
# Render the Quarto site in docs-src/ and copy it into inst/docs/.
set -euo pipefail

cd "$(dirname "$0")"
quarto render docs-src
rm -rf inst/docs
mkdir -p inst
cp -r docs-src/_site inst/docs
echo "Docs copied to inst/docs/"
