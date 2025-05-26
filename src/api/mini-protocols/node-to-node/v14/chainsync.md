# ChainSync CDDL

The CDDL specification for ChainSync in the Cardano network is
composed by the combination of the following files (from [the `cddl`
folder](https://github.com/cardano-scaling/cardano-blueprint/tree/main/src/api/cddl)
of the blueprints repository):

```
cddl
├── mini-protocols
│   └── v14
│        └── chainsync
│            ├── messages.cddl
│            └── header.cddl
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
;; cddl/node-to-node/v14/chainsync/messages.cddl
{{#include ../../../cddl/node-to-node/v14/chainsync/messages.cddl}}
```

The header is a tag-encoded value that contains CBOR-in-CBOR headers
for the particular era:

```cddl
;; cddl/node-to-node/v14/chainsync/header.cddl
{{#include ../../../cddl/node-to-node/v14/chainsync/header.cddl}}
```
