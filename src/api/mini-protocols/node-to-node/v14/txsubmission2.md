# TxSubmission2 CDDL

The CDDL specification for TxSubmission2 in the Cardano network is
composed by the combination of the following files (from [the `cddl`
folder](https://github.com/cardano-scaling/cardano-blueprint/tree/main/src/api/cddl)
of the blueprints repository):

```
cddl
├── mini-protocols
│   └── v14
│        └── txsubmission2
│            ├── messages.cddl
│            ├── tx.cddl
│            └── txid.cddl
├── base.cddl
└── ledger
    ├── byron.cddl
    ├── shelley.cddl
    ├── allegra.cddl
    ├── mary.cddl
    ├── alonzo.cddl
    ├── babbage.cddl
    └── conway.cddl
```

The messages depicted in the state machine follow this CDDL specification:

```cddl
;; cddl/node-to-node/v14/txsubmission2/messages.cddl
{{#include ../../../cddl/node-to-node/v14/txsubmission2/messages.cddl}}
```

A transaction ID is a tag-encoded alternative of the transaction IDs
for each of the eras. Note that in Byron there are 4 alternatives for
a transaction ID:

```cddl
;; cddl/node-to-node/v14/txsubmission2/txid.cddl
{{#include ../../../cddl/node-to-node/v14/txsubmission2/txid.cddl}}
```

A transaction as transmitted in TxSubmission2 is a tag-encoded
alternative of the transactions for each of the eras. Note that for
Shelley-onwards, the transaction is serialized in CBOR-in-CBOR:

```cddl
;; cddl/node-to-node/v14/txsubmission2/tx.cddl
{{#include ../../../cddl/node-to-node/v14/txsubmission2/tx.cddl}}
```
