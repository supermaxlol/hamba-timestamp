#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "== Verifying ROOT.txt timestamp =="
openssl ts -verify -data ROOT.txt -in ROOT.txt.tsr -CAfile freetsa-cacert.pem -untrusted freetsa-tsa.crt

echo
echo "== Verifying KEY_ARTEFACTS.sha256 timestamp =="
openssl ts -verify -data KEY_ARTEFACTS.sha256 -in KEY_ARTEFACTS.sha256.tsr -CAfile freetsa-cacert.pem -untrusted freetsa-tsa.crt

echo
echo "== Certified time =="
openssl ts -reply -in ROOT.txt.tsr -text | grep -E "Status:|Time stamp:" || true

echo
echo "All checks passed."
