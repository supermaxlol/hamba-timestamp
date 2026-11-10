# Hamba evidence timestamp

This repository is a **public, third-party timestamp record** for the Hamba workspace.

It does not contain the work. It contains cryptographic commitments to the work and an RFC 3161 timestamp token issued by [FreeTSA](https://freetsa.org) at **2026-11-10 14:23:49 UTC**. Anyone can verify, without trusting me, that the files named in these manifests existed in exactly this form no later than that time.

## What is committed

| File | Purpose |
|---|---|
| `ROOT.txt` | The dated commitment: SHA-256 of `MANIFEST.sha256` (2,635 entries covering the full committed tree), SHA-256 of `KEY_ARTEFACTS.sha256`, and the source commit `36382978a160fc56a3960d91c37284c7b3fb004e` in the private repository `supermaxlol/hamba`. |
| `ROOT.txt.tsq` / `ROOT.txt.tsr` | RFC 3161 timestamp query and signed response for `ROOT.txt`. |
| `KEY_ARTEFACTS.sha256` | SHA-256 hashes of the 14 documents named in Schedule A Appendix A and the i2i agreement bundle (business plan, white paper, pitch, reproduced validation CSVs, registers, and the signed agreement PDF). |
| `KEY_ARTEFACTS.sha256.tsq` / `KEY_ARTEFACTS.sha256.tsr` | RFC 3161 timestamp query and signed response for `KEY_ARTEFACTS.sha256`. |
| `freetsa-tsa.crt`, `freetsa-cacert.pem` | The FreeTSA certificate chain used for verification. |

The full `MANIFEST.sha256` (all filenames and hashes) is not published here. Publishing `ROOT.txt` commits to it without disclosing the file tree. To prove any specific file later, I can reveal the manifest and anyone can recompute its hash to match the value recorded in `ROOT.txt`, then locate the file's hash inside it.

## Verify

Requirements: `openssl` (3.x recommended) and `shasum` (macOS) or `sha256sum`.

```bash
# 1. Verify the FreeTSA timestamp on the root commitment
openssl ts -verify \
  -data ROOT.txt \
  -in ROOT.txt.tsr \
  -CAfile freetsa-cacert.pem \
  -untrusted freetsa-tsa.crt

# 2. Verify the FreeTSA timestamp on the key-artefacts list
openssl ts -verify \
  -data KEY_ARTEFACTS.sha256 \
  -in KEY_ARTEFACTS.sha256.tsr \
  -CAfile freetsa-cacert.pem \
  -untrusted freetsa-tsa.crt

# 3. Inspect the certified time
openssl ts -reply -in ROOT.txt.tsr -text | grep -E "Status|Time stamp"
```

Expected: `Verification: OK` for both commands, and `Time stamp: Nov 10 14:23:49 2026 GMT`.

To verify a key artefact against this record: compute its SHA-256 and confirm the value appears in `KEY_ARTEFACTS.sha256`.

```bash
shasum -a 256 /path/to/HAMBA_Consolidated_Business_Plan_v2.3.md
grep HAMBA_Consolidated_Business_Plan_v2.3.md KEY_ARTEFACTS.sha256
```

## What this proves, and what it does not

**Proves:** the byte-exact contents of `ROOT.txt` and `KEY_ARTEFACTS.sha256` existed at or before the time certified by FreeTSA. Because `ROOT.txt` records the hash of the full manifest, it also commits to every file in that manifest: changing any one byte of any one file would change the manifest and break the root hash.

**Does not prove:** who created the files, whether the claims inside them are true, or that the work was not created earlier than the timestamp. A timestamp is a lower bound on *when it was attested*, not an upper bound on when it was written.

The content, the private repository, and the dated working documents remain the primary evidence. This record makes that evidence verifiable by a third party.
