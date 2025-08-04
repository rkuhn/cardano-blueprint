# Ledger

> [!WARNING]
>
> This blueprint is a work in progress.

The Ledger is responsible for validating Blocks and represents the actual semantics of Cardano transactions. The format of blocks and transactions is defined in so-called **eras**: `Byron`, `Shelley`, `Allegra`, `Mary`, `Alonzo`, `Babbage` and `Conway`.

This blueprint is currently more of an entrypoint to already existing implementation-independent descriptions of Cardano transactions and the ledger rules. While existing work covers a lot already, the `cardano-blueprint` may serve as an incubation or staging area for material to cover gaps.

For starters, the [EUTxO Crash Course](https://aiken-lang.org/fundamentals/eutxo) from Aiken is a very good introduction about Cardano transactions.

See [Transaction fee](./transaction-fee.md) for an informal write-up on how transaction fees are currently calculated.

## Ledger rules

The [Formal Specification](https://intersectmbo.github.io/formal-ledger-specifications/site/index.html) is the source of truth for ledger semantics. While it is currently being made more accessible by interleaving explanations with Agda definitions, its very dense on the Agda and actively worked on to close the gap latest era descriptions and the old era definitions. The Haskell implementation of the ledger holds a list of [design documents and ledger specifications](https://github.com/IntersectMBO/cardano-ledger?tab=readme-ov-file#cardano-ledger) for all eras.

See [Block Validation](./block-validation.md) for a description of the `Conway` era block validation rules.

## Block and transaction format

The [.cddl files in cardano-ledger](https://github.com/search?q=repo%3AIntersectMBO%2Fcardano-ledger+path%3A.cddl&type=code) define the wire-format of blocks and transactions for each era. These are self-contained for each
era and are referenced in [other blueprint CDDL schemas](../codecs#cddl).

> [!WARNING]
> TODO: make ledger cddls available through blueprint directly

## Conformance tests

Despite the formal specification provides a precise definition for semantics, testing the behavior of ledger implementations against the specification and also the ledger implementations against each other is crucial. For this purpose, a conformance test suite with [implementation-independent test vectors](https://github.com/cardano-scaling/cardano-blueprint/tree/main/src/ledger/conformance-test-vectors) can be used.
