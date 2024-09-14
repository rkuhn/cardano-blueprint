# Introduction

This document is an exploration on the `cardano-node` architecture and how it could be made more modular, approachable and flexible.

## Why should we care

The Cardano Node was developed over the last 5+ years to become the reference implementation of the Ouroboros consensus protocols, extended UTxO (eUTxO) ledger model and plutus smart contract language at Input Output Group (IOG, or just IO).

While based on peer-reviewed research and significant engineering efforts in ensuring correctness through formal methods with extensive testing, the **codebase is largely opaque** for non-IO Cardano developers and definitely unused outside of the Cardano ecosystem. For example, it is concerning that even IO's sister projects to Cardano like Midnight and Partner-Chains were reaching to other frameworks to build their blockchain components, despite building sidechains of Cardano.

While there will always be demand for "node diversity" in a public blockchain and multiple teams using their favorite tools and languages to build them, we must not shy away of making the ways the Cardano node is built **more approachable** to a wider developer community. This will not only improve development capacity, but also enable maintenance to outlive the current company & team structures. Furthermore, if we could make the components of the Cardano node be re-used **more flexibly** in diverse scenarios, this would lead to a rich feature-set and at the same time counter-act natural fragmentation to a healthy balance.

After all, software quality is not only about rigor and testing, but also "how easy a system can be changed".
