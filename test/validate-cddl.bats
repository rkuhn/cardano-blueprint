#!/usr/bin/env bats
#
# Validate CDDL specifications in the repository.
#
# Uses 'cddlc' to resolve module imports (;# import/include pragmas) and
# checks that no undefined names remain in the merged output.
#
# Era CDDL files (byron, shelley, ..., conway) are downloaded from
# cardano-ledger at runtime since they are not part of this repository.
#
# Run with: bats validate-cddl.bats
# Requirements: bats, cddlc, curl

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
LEDGER_RAW="https://raw.githubusercontent.com/IntersectMBO/cardano-ledger/master"

# Include paths for cddlc to resolve ';# import/include MODULE as PREFIX' pragmas.
# Add new source directories here when new modules are introduced.
SRC_INCLUDE_PATHS=(
  "$REPO_ROOT/src/codecs"
  "$REPO_ROOT/src/network/node-to-node/blockfetch"
  "$REPO_ROOT/src/network/node-to-node/chainsync"
  "$REPO_ROOT/src/network/node-to-node/txsubmission2"
)

@test "network/node-to-node/blockfetch/messages.cddl" {
  validate_cddl src/network/node-to-node/blockfetch/messages.cddl
}

@test "network/node-to-node/chainsync/messages.cddl" {
  validate_cddl src/network/node-to-node/chainsync/messages.cddl
}

@test "network/node-to-node/handshake/messages.cddl" {
  validate_cddl src/network/node-to-node/handshake/messages.cddl
}

@test "network/node-to-node/keep-alive/messages.cddl" {
  validate_cddl src/network/node-to-node/keep-alive/messages.cddl
}

@test "network/node-to-node/txsubmission2/messages.cddl" {
  validate_cddl src/network/node-to-node/txsubmission2/messages.cddl
}

@test "client/node-to-client/state-query/messages.cddl" {
  validate_cddl src/client/node-to-client/state-query/messages.cddl
}

setup_file() {
  ERA_DIR="$(mktemp -d ledger-era-cddls.XXX)"
  export ERA_DIR

  echo "# Downloading era CDDL files from cardano-ledger..." >&3
  for era in allegra alonzo babbage conway mary shelley; do
    curl -sSfL "$LEDGER_RAW/eras/$era/impl/cddl/data/$era.cddl" -o "$ERA_DIR/$era.cddl"
  done
  curl -sSfL "$LEDGER_RAW/eras/byron/ledger/impl/cddl-spec/byron.cddl" -o "$ERA_DIR/byron.cddl"

  local IFS=":"
  export CDDL_INCLUDE_PATH="${SRC_INCLUDE_PATHS[*]}:$ERA_DIR"
  echo "# CDDL_INCLUDE_PATH=$CDDL_INCLUDE_PATH" >&3
}

teardown_file() {
  rm -rf "$ERA_DIR"
}

# Run cddlc on a CDDL file and fail if any names are undefined.
# Usage: validate_cddl <path-relative-to-REPO_ROOT>
validate_cddl() {
  local rel="$1"
  local file="$REPO_ROOT/$rel"

  run bash -c "cddlc -u -2 -t cddl '$file' 2>&1"
  echo "$output"
  echo ""
  echo "Reproduce: CDDL_INCLUDE_PATH=$CDDL_INCLUDE_PATH cddlc -u -2 -t cddl $file"
  [ "$status" -eq 0 ]
  [[ "$output" != *"*** undefined"* ]]
}
