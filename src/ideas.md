# Ideas

Driving forces that could improve the situation of the Cardano node architecture.

## Interface first
- Conformance tests
- CIPs?
- Open standards / avoid not invented here / off-the-shelf especially close to the user

<!--
Which is a shame, because there is even a need for variants _within_ the Cardano network. For example: making the cardano ledger state available to other applications, so-called "indexers". The tricky thing with this is that there exists as many opinions in how that data should be made available as there are use cases and developers out there. Some prefer a `PostgreSQL` database ([DBSync](https://github.com/IntersectMBO/cardano-db-sync), [karp](https://github.com/dcSpark/carp)), while others fancy more light-weight `SQLite` ([kupo](https://github.com/CardanoSolutions/kupo)), or programmable filters ([scrolls](https://github.com/txpipe/scrolls)). (There are even more indexers and variants cropping up by the day)

With the `cardano-node` being architected (or at least communicated through this [prominent diagram](https://docs.cardano.org/about-cardano/explore-more/cardano-architecture/)) as that opaque, impenetratable component, the only option these ...

While there have been many indexers for all kinds of `DBSync` in particular is ..
-->

## Is Haskell a deterrent?

- Current teams / components are not a "bad cut" per se
- Communication the issue? demonstrate re-use?
- Without external contributions, tight (process) coupling ensues
- Feature teams concerning about one aspect across components?

- Competing implementations was already tried in the past
  - Rust vs. Haskell -> Jormungandr vs. cardano-node


## Case study: mithril

- Evolution from userspace to kernel
- How can experiments and new ideas transcend into "the node" eventually?
- Mithril completely separate -> Mithril side-car / network re-use -> Signer part of node -> Use signed data in node (for consensus)
