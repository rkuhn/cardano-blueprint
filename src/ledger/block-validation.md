# Ledger: Block Validation

Block validation is the process of applying a set of ledger rules to a candidate block before adding it to the blockchain and updating the state of the ledger.
Each [era](../consensus/README.md#multi-era-considerations) has it's own set of rules for block validation.



> [!NOTE]
> TODO: Write a full introduction here with relevant terminology and concepts defined.

While different node implementations may implement these rules in different ways, it's vital that they all agree on the outcome of the validation process to prevent forks in the blockchain.


## Conway Block Validation

In this section, we will walk through the [cardano-ledger](https://github.com/IntersectMBO/cardano-ledger) implementation of Conway era block validation.
We will break up the validation process into smaller sections to make it easier to visualize and understand. All diagrams should be read from left to right and top to bottom in terms of order of execution.


The [cardano-ledger](https://github.com/IntersectMBO/cardano-ledger) has the concept of an _EraRule_, which is a set of validations that are applied to a block in a specific era. Often, a newer era may call a previous era's EraRule instead of reimplementing the same logic.
### EraRule BBODY
This is the "entrypoint" for block validation, responsible for validating the body of a block.
```mermaid
{{#include diagrams/conway-bbody.mermaid}}
```

### EraRule LEDGERS
This EraRule is responsible for validating and updating the ledger state, namely UTxO state, governance state, and certificate state.
```mermaid
{{#include diagrams/conway-ledgers.mermaid}}
```

### EraRule CERTS
This EraRule is responsible for validating and updating the certificate state.
```mermaid
{{#include diagrams/conway-certs.mermaid}}
```


### EraRule GOV
This EraRule is responsible for validating and updating the governance state.
```mermaid
{{#include diagrams/conway-gov.mermaid}}
```


### EraRule UTXOW
This EraRule is responsible for validating and updating the UTxO state.
```mermaid
{{#include diagrams/conway-utxos.mermaid}}
```


### Full Diagram
Here is the full diagram, with all EraRules combined.
```mermaid
{{#include diagrams/conway-block-validation.mermaid}}
```
