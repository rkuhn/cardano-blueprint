# The ledger state transition

The ledger can be fundamentally seen as a state transition function. Given a
ledger state and a signal (typically a block) we return a new ledger state.

In the formal modeling of the ledger, we allow a slightly richer definition in
order to bring more clarity. As such, we think of the ledger transition function
as having three parts:

- The *Environment*. This consists of "read-only" data which can affect the
  transition. This might consist of things such as as the protocol parameters
  or the current slot or block number.

- The *State*. This is the current state of the ledger. It includes obvious
  things such as the UTxO set.

- The *Signal*. The signal is what drives evolution of the ledger. There are
  three top-level signals which the ledger has to consider:

  - A *block body*. When a new block is added to the chain, the state is
    updated. Since the ledger is concerned only with the
    [block body](./concepts/blocks.md), that is the part which drives the state
    transition.
    
  - A *transaction*. This is needed to validate transactions when they enter
    the mempool, before including them into a block.

  - A *tick*. This represents time moving on. Sometimes the state of the
    ledger updates just due to time moving - for example, at an epoch boundary.

The question of validity is determined inductively from an initial state. A
transaction is valid with respect to some state if one can correctly apply the
transition function to yield a new state, which is then itself considered valid.

We discuss the question of validity for transactions and blocks in
[Validity](./state-transition/validity.md). Ticks must always be valid - if we
are in a situation where we cannot advance time in a valid fashion, then we
are in a very bad situation indeed!

The ledger state transition function must execute identically on each node in
the network. Consequently, the full function is defined in the ledger specs -
formal or semi-formal expressions of the computation to be performed. More
detail on how to read the specs is detailed in
[How to read the ledger specs](./state-transition/reading-specs.md)
