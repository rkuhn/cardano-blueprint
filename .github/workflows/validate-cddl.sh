#!/usr/bin/env bash
# Validate CDDL specifications in the repository.
#
# Uses 'cddlc' to resolve module imports (;# import/include pragmas) and
# checks that no undefined names remain in the merged output.
#
# Era CDDL files (byron, shelley, ..., conway) are downloaded from
# cardano-ledger at runtime since they are not part of this repository.
#
# Requirements: cddlc, curl

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LEDGER_RAW="https://raw.githubusercontent.com/IntersectMBO/cardano-ledger/master"

# Entry-point CDDL files to validate (relative to REPO_ROOT).
# Each file is merged with its imports by cddlc and checked for undefined names.
ENTRY_POINTS=(
  src/network/node-to-node/blockfetch/messages.cddl
  src/network/node-to-node/chainsync/messages.cddl
  src/network/node-to-node/handshake/messages.cddl
  src/network/node-to-node/keep-alive/messages.cddl
  src/network/node-to-node/txsubmission2/messages.cddl
  src/client/node-to-client/state-query/messages.cddl
)

ERA_DIR="$(mktemp -d)"
trap 'rm -rf "$ERA_DIR"' EXIT

echo "==> Downloading era CDDL files from cardano-ledger..."
for era in allegra alonzo babbage conway mary shelley; do
  curl -sSfL "$LEDGER_RAW/eras/$era/impl/cddl/data/$era.cddl" -o "$ERA_DIR/$era.cddl"
  echo "    $era.cddl"
done
curl -sSfL "$LEDGER_RAW/eras/byron/ledger/impl/cddl-spec/byron.cddl" -o "$ERA_DIR/byron.cddl"
echo "    byron.cddl"

# cddlc resolves ';# import/include MODULE as PREFIX' pragmas by looking for
# MODULE.cddl in the colon-separated CDDL_INCLUDE_PATH directories.
export CDDL_INCLUDE_PATH
CDDL_INCLUDE_PATH="$REPO_ROOT/src/codecs"
CDDL_INCLUDE_PATH+=":$REPO_ROOT/src/network/node-to-node/blockfetch"
CDDL_INCLUDE_PATH+=":$REPO_ROOT/src/network/node-to-node/chainsync"
CDDL_INCLUDE_PATH+=":$REPO_ROOT/src/network/node-to-node/txsubmission2"
CDDL_INCLUDE_PATH+=":$ERA_DIR"

echo ""
echo "==> Validating CDDL entry points..."
echo "    CDDL_INCLUDE_PATH=$CDDL_INCLUDE_PATH"
echo ""
errors=0

for rel in "${ENTRY_POINTS[@]}"; do
  f="$REPO_ROOT/$rel"
  echo -n "  $rel ... "

  merged="$(mktemp --suffix=.cddl)"
  stderr_file="$(mktemp)"

  cmd="CDDL_INCLUDE_PATH=$CDDL_INCLUDE_PATH cddlc -u -2 -t cddl $f"

  if ! cddlc -u -2 -t cddl "$f" >"$merged" 2>"$stderr_file"; then
    echo "FAILED"
    echo "    Reproduce with: $cmd"
    echo "    cddlc error:"
    sed 's/^/      /' "$stderr_file"
    errors=$((errors + 1))
    rm -f "$merged" "$stderr_file"
    continue
  fi

  if grep -q "\*\*\* undefined" "$merged"; then
    echo "FAILED"
    echo "    Reproduce with: $cmd"
    echo "    undefined references:"
    grep "\*\*\* undefined" "$merged" | sed 's/^/      /'
    errors=$((errors + 1))
    rm -f "$merged" "$stderr_file"
    continue
  fi

  rm -f "$merged" "$stderr_file"
  echo "OK"
done

echo ""
if [[ $errors -gt 0 ]]; then
  echo "==> $errors file(s) failed validation"
  exit 1
fi
echo "==> All CDDL files validated successfully"
