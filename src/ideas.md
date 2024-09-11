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

## Is Haskell a deterrent?

- Current teams / components are not a "bad cut" per se
- Without external contributions, tight (process) coupling ensues
- Feature teams concerning about one aspect across components?

## Case study: mithril

- Evolution from userspace to kernel
- How can experiments and new ideas transcend into "the node" eventually?
- Mithril completely separate -> Mithril side-car / network re-use -> Signer part of node -> Use signed data in node (for consensus)
