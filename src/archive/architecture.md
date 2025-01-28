# Node architecture

> [!WARNING]
> This was a collection / write-up for a different purpose

While some documentation for [users](https://docs.cardano.org/about-cardano/explore-more/cardano-architecture/) and [developers](https://developers.cardano.org/docs/get-started/cardano-node/cardano-components) can be found, the available documents about the "inner workings" of the Cardano node is scarce.

The main repository is [cardano-node](https://github.com/IntersectMBO/cardano-node) which integrates the several components. The linked repository do contain individual Haskell package dependency diagrams and bigger technical specification documents, but generally it's quite hard to read about how the various components interact with each other.

The lack of an easy accessible and clear visual breakdown of the individual responsibilities of a `cardano-node` and how they could be re-used is maybe already a hint to why external contributors are seeing it as non-inviting to be re-used or extended. In fact, the rotating release engineers at IO even needed to come up with dependency diagrams on their own to get an overview (for example Yura and his mermaid diagram).

For this document, the following diagram of relevant components and their relations will make do:

![](components.excalidraw.svg)

> [!NOTE]
> TODO: Introduce relevant components sufficient for remainder of document

### Plutus

- Plutus Intermediate Representation (IR) and Plutus Core syntax
- Plutus Core interpreter
- Cost model estimation
- plutus-tx / plinth is separate, compiler to build plutus core

### Ledger
- Validates transactions according to ledger rules
- Updates stake distribution
- Keeps reward accounts
- Governance features?
- Could host multiple languages (not only plutus)!

### Consensus
- Ledger eras (here? or above)
- Chain selection
- Hard-fork combinator
- Multiple consensus protocols that determine which blocks are valid and who to mint them
- Currently: Praos, TPraos, PBFT (still?)

### Network
- Node-to-node
  - BlockFetch
  - ChainSync
  - TxSubmission
- Node-to-client
  - Local variants of chain sync and tx submission
  - State Query
  - Mempool monitor
