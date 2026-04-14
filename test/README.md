# Tests

This directory contains automated tests for the specifications in this repository.

## CDDL validation

[`validate-cddl.bats`](validate-cddl.bats) is a [bats](https://github.com/bats-core/bats-core) test suite that checks the CDDL network protocol specifications for consistency.

Each test validates one `messages.cddl` entry-point file by:

1. Using `cddlc` to resolve all `; # import`/`; # include` module directives and merge the imported files into a single flat CDDL document.
2. Checking that the merged output contains no undefined type references (reported by `cddlc -u` as `*** undefined: …` comments).

Because the era-specific CDDL files (Byron, Shelley, …, Conway) live in [cardano-ledger](https://github.com/IntersectMBO/cardano-ledger) rather than this repository, the test suite downloads them at runtime.

### Running locally

With `bats` and `cddlc` available (e.g. via `nix develop`):

```shell
bats test/validate-cddl.bats
```

When a test fails the output includes a ready-to-run `cddlc` invocation so you can inspect the merged CDDL directly:

```
# Reproduce: CDDL_INCLUDE_PATH=… cddlc -u -2 -t cddl src/…/messages.cddl
```
