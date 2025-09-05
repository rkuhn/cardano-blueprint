# Determinism

An important principle that occurs in a few places throughout the Cardano ledger
is that of determinism. Perhaps one way to summarise is would be to say: "the
transaction is all you need" - that is, when trying to compute the results of
a transaction, you need only look at the transaction itself rather than
computing with the full ledger state.

There are two important instantiations of this principle:

## Transaction Determinism

This instance tells us that, given a transaction is valid, its outputs are
determined fully by the transaction itself. It may be necessary to look at
certain parts of the ledger state to determine whether it is valid - for
example, to check that the inputs have not been spent - but assuming it is
valid, the outputs created will be exactly as described in the transaction.

## Script determinism

This instance tells us that, assuming a transaction passes phase 1 validation,
the validity of a script is determined only by data contained in the transaction
and in the transaction outputs that it spends or references.

## Implications for Node Implementors

These properties allow node implementors to safely make certain assumptions
which can speed up transaction and block processing.

1. When processing historical blocks, nodes need only consider (or even
   deserialise) [transaction bodies](./blocks.md), since the rest of the
   block payload can only impact the block _validity_, which is already known
   for historical blocks.
2. Many of the more expensive checks of transaction validity need only be
   carried out once. In particular, the cryptographic verification and script
   execution need only be carried out once, when the transaction first enters
   the mempool. Subsequently it is required only to check that the inputs still
   exist.

To take advantage of these properties, ledger implementers must distinguish
between these checks in the ledger in such a way as to allow transactions to be
(re-)processed without repeating expensive computation.
