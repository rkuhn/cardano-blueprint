# Introduction

This document is an exploration on the `cardano-node` architecture and how it could be made more modular, approachable and flexible.

## Why should we care

The Cardano Node was developed over the last 5+ years as the reference implementations of the Ouroboros consensus, extended UTxO (eUTxO) account model and plutus smart contract language at Input Output Group (IOG, or just IO).

While based on peer-reviewed research and significant engineering efforts in ensuring correctness through formal methods with extensive testing, the **codebase is largely opaque** for non-IO Cardano developers and definitely unused outside of the Cardano ecosystem. For example, it is concerning that even IO's sister projects to Cardano like Midnight and Partner-Chains were reaching to other frameworks to build their blockchain components, despite building sidechains of Cardano.

Making the ways the Cardano node is built **more approachable** to a wider developer community would not only improve development capacity, but also enable maintenance to outlive the current company & team structures. Furthermore, if we could make the components of the Cardano node be re-used **more flexibly** in diverse scenarios, this would lead to a richer feature-set.

After all, software quality is not only about rigor and testing, but also "how easy a system can be changed".

## Node architecture

While some documentation for [users](https://docs.cardano.org/about-cardano/explore-more/cardano-architecture/) and [developers](https://developers.cardano.org/docs/get-started/cardano-node/cardano-components) can be found, the available documents about the "inner workings" of the Cardano node is scarce.

The main repository is [cardano-node](https://github.com/IntersectMBO/cardano-node) which integrates the several components. The linked repository do contain individual Haskell package dependency diagrams and bigger technical specification documents, but generally it's quite hard to read about how the various components interact with each other.

The lack of an easy accessible and clear visual breakdown of the individual responsibilities of a `cardano-node` and how they could be re-used is maybe already a hint to why external contributors are seeing it as non-inviting to be re-used or extended. In fact, the rotating release engineers at IO even needed to come up with dependency diagrams on their own to get an overview (for example Yura and his mermaid diagram).

For this document, the following diagram of relevant components and their relations will make do:

![](components.excalidraw.svg)

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


# Ideas

Driving forces that could improve the situation of the Cardano node architecture.

## Alternatives 

Modularization and interfaces are only enforced when there are alternatives.

For each interface, either maintain multiple alternatives or realize that its not modular.

- Alternative implementations of components
  - Is PBFT still maintained?
  - Alternative ledger to enforce separation?
  - Plutus intended to be only one of many interpreters - is it really losely coupled?

- Alternative compositions / variants of nodes
  - Permissioned nodes?
  - Client / data nodes with different storage requirements

## Interface first
- Conformance tests
- CIPs?

## Is Haskell a deterrent?

- Current teams / components are not a "bad cut" per se
- Without external contributions, tight (process) coupling ensues
- Feature teams concerning about one aspect across components?

- Competing implementations was already tried in the past
  - Rust vs. Haskell -> Jormungandr vs. cardano-node

## Case study: mithril

- Evolution from userspace to kernel
- How can experiments and new ideas transcend into "the node" eventually?
- Mithril completely separate -> Mithril side-car / network re-use -> Signer part of node -> Use signed data in node (for consensus)
