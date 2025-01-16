# Introduction

Welcome to the Cardano Blueprint, a project that aims to serve as a
knowledge foundation about _how_ the Cardano blockchain is
built. Blueprints are implementation-independent assets, diagrams,
specifications, test data, etc. that will enable a wide developer
audience to understand and build on Cardano.

## Why it's needed

The Cardano Node was developed over the last 8+ years to become the
reference implementation of the Ouroboros consensus protocols,
extended UTxO (eUTxO) ledger model and Plutus smart contract language
at Input Output Group (IO).

All of these things are documented, but the documentation is spread across
multiple repositories, in different formats, some in very dense formal
methods syntax, and some mixed with implementation details of the Haskell node.

This project aims to produce a 'greenfield' set of blueprints for Cardano,
which are:

* Collected together in a single place
* Expressed in a single, universal format (markdown)
* Written for ordinary software developers
* Abstracted from any particular implementation

The audience includes:

* Developers in the node teams who are new or may need information
  outside their current area
* Developers in other teams in IO and external partners, wishing to
  integrate with the node
* Developers of future alternative nodes and clients
* Anyone wanting to understand Cardano at a deeper technical level

Hosting this project
[on Github](https://github.com/cardano-scaling/cardano-blueprint) means
that it can become a community effort with all the usual processes of
a good Open Source software project - Pull Requests, reviews, issues,
branches, release tags...

## What makes a good blueprint

A good blueprint should be:

* **Abstract** - it should define protocols and behaviour, not code
* **Accessible** - it should be written so any competent software engineer.
  with some knowledge of the field can understand it - think about the level
  of a typical Internet RFC.  It should use diagrams
  (in [Mermaid](https://mermaid.js.org/)) to help understanding.
* **Complete** - it should contain *all* the information required to implement
  the component, not refer to any external source (which may go out of date).
* **Minimal** - it should define what an implementation *must* do (and see
  the [Style Guide](./styleguide.md) for how to express this) and leave
  implementation details to implementors.
* **Up to date** - it should be kept up to date with any changes - ideally
  leading and informing them rather than the other way round.

## What about Cardano Improvement Proposals (CIPs)?

> [!NOTE]
> TODO: State how this relates to CIPs

- Perfect for new features and discussion
- Blueprints will try to live up to the CIP process
- CIPs are incremental, creating a big picture proposal-by-proposal
- Blueprint aims to aggregate by default
- Retroactively distilling knowledge, hence more flexible in the beginning
- Should ratify Blueprint approach as CIP!
