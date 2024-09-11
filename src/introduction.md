# Introduction

This document is an exploration on the `cardano-node` architecture and how it could be made more modular, approachable and flexible.

## Why

The Cardano Node was developed over the last 5+ years as the reference implementations of the Ouroboros consensus, extended UTxO (eUTxO) account model and plutus smart contract language at Input Output Group (IOG, or just IO).

While based on peer-reviewed research and significant engineering efforts in ensuring correctness through formal methods with extensive testing, the codebase is largely opaque for non-IO Cardano developers and definitely unused outside of the Cardano ecosystem. For example, it is concerning that even IO's sister projects to Cardano like Midnight and Partner-Chains were reaching to other frameworks to build their blockchain components, despite building sidechains of Cardano.

Making the ways the Cardano node is built **more approachable** to a wider developer community would not only improve development capacity, but also enable maintenance to outlive the current company & team structures. Furthermore, if we could make the components of the Cardano node be re-used **more flexibly** in diverse scenarios, this would lead to a richer feature-set.

After all, software quality is not only about rigor and testing, but also "how easy a system can be changed".


