#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "== Initial set: ROOT.txt (3638297, 2026-11-10 14:23:49 UTC) =="
openssl ts -verify -data ROOT.txt -in ROOT.txt.tsr -CAfile freetsa-cacert.pem -untrusted freetsa-tsa.crt
openssl ts -verify -data KEY_ARTEFACTS.sha256 -in KEY_ARTEFACTS.sha256.tsr -CAfile freetsa-cacert.pem -untrusted freetsa-tsa.crt

echo
echo "== Supplemental set: ROOT_77ac227.txt (77ac227, 2026-11-10 14:43:47 UTC) =="
openssl ts -verify -data ROOT_77ac227.txt -in ROOT_77ac227.txt.tsr -CAfile freetsa-cacert.pem -untrusted freetsa-tsa.crt
openssl ts -verify -data KEY_ARTEFACTS_77ac227.sha256 -in KEY_ARTEFACTS_77ac227.sha256.tsr -CAfile freetsa-cacert.pem -untrusted freetsa-tsa.crt

echo
echo "== Certified times =="
openssl ts -reply -in ROOT.txt.tsr -text | grep -E "Status:|Time stamp:" || true
openssl ts -reply -in ROOT_77ac227.txt.tsr -text | grep -E "Status:|Time stamp:" || true

echo
echo "All checks passed."
