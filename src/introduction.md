# Introduction

Welcome to the Cardano Blueprint, a project that aims to serve as a knowledge foundation about _how_ the Cardano blockchain is built. Blueprints are implementation independent assets, diagrams, specifications, test data, etc. that will enable a wide developer audience to understand and build on Cardano. 

## Why should we care

> [!NOTE]
> TODO: Reword into a better _why_, this was more about why node architecture should be improved


The Cardano Node was developed over the last 8+ years to become the reference implementation of the Ouroboros consensus protocols, extended UTxO (eUTxO) ledger model and plutus smart contract language at Input Output Group (IOG, or just IO).

While based on peer-reviewed research and significant engineering efforts in ensuring correctness through formal methods with extensive testing, the **codebase is largely opaque** for non-IO Cardano developers and definitely unused outside of the Cardano ecosystem. For example, it is concerning that even IO's sister projects to Cardano like Midnight and Partner-Chains were reaching to other frameworks to build their blockchain components, despite building sidechains of Cardano.

There will always be demand for "node diversity" in a public blockchain and multiple teams using their favorite tools and languages to build them. Hence, we must not shy away of making the ways the Cardano node is built **more approachable** to a wider developer community. This will not only improve development capacity, but also enable maintenance to outlive the current company & team structures. Furthermore, if we could make the components of the Cardano node be re-used **more flexibly** in diverse scenarios, this would lead to a rich feature-set and at the same time counter-act natural fragmentation to a healthy balance.

After all, software quality is not only about rigor and testing, but also "how easy a system can be changed".

## What makes a good blueprint

> [!NOTE]
> TODO: Introduce our values

## What about Cardano Improvement Proposals (CIPs)?

> [!NOTE]
> TODO: State how this relates to CIPs

- Perfect for new features and discussion
- Blueprints will try to live up to the CIP process
- CIPs are incremental, creating a big picture proposal-by-proposal
- Blueprint aims to aggregate by default
- Retroactively distilling knowledge, hence more flexible in the beginning
- Should ratify Blueprint approach as CIP!
