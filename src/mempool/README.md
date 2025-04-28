# Mempool

In Cardano, for blocks to have useful data, they have to contain transactions,
which are codifications of operations on the Ledger state that only some
authorized actors can enact. Notice that such transactions are what makes up the
contents of the block. In one way, one could see the ledger as being able to
validate transactions, and by implication full blocks as those are mainly
collections of transactions.

The Mempool is the abstract component of the node that stores transactions which
are valid on top of the latest known Ledger State (the one at the tip of the
chain selected by [Chain Selection](../consensus/chainsel.md) in the Consensus
layer). The validity of transactions is defined by the Ledger layer. Notice a
change in the selected chain should trigger a prompt revalidation of the pending
transactions to discard those that became invalid on the new selection.  Such
collection of valid transactions will be requested by the Consensus layer to
[forge new blocks](../consensus/forging.md).

Once a transaction has been included in some block, it cannot be a _pending
transaction_ anymore, in fact from that point onwards it will be an _invalid
transaction_, as in Cardano every transaction consumes at least one UTxO, in
this case consumed by the instance of the transaction that was included in a
block.

> [!NOTE]
>
> Notice that a transaction might be considered valid in one peer, but invalid
> in another peer which has selected a different chain. Even in the case both
> peers have the same selection, the existence in the mempool (or lack thereof)
> of some other specific transaction that creates (or consumes) the inputs for
> this one could lead to different verdicts on each peer.

While only nodes that forge new blocks will use these transactions to create
blocks, non-block-producing nodes are still expected to diffuse transactions to
their peers. **All participating nodes** must be able to receive, validate, and
distribute transactions.

> [!TIP]
>
> When a node is shut down, the implementation can choose what to do with the
> pending transactions. The reference Haskell implementation discards them.
> However, it is conceivable for a node to store on disk the pending
> transactions from its mempool.

The [`TxSubmission2`](./txsubmission2.md) miniprotocol is the
one used to diffuse the pending transactions through the network.

To be able to diffuse transactions through `TxSubmission2` and to fulfill the
requirements of the Consensus layer, any mempool implementation has the
following requirements:
- Acquiring a snapshot of valid transactions for a newly forged block should be
  as fast as possible, as it will delay all other steps in the diffusion of such
  a block. This is required by the Consensus layer for [forging
  blocks](../consensus/forging.md).
- Cursor-like access to pending transactions. This is required by the
  `TxSubmission2` protocol.
- Re-validation on a new selected chain: it is useless to keep transactions that
  are no longer valid in the mempool. This is an inherent requirement of the
  mempool itself.

Notice that _what_ a transaction actually is defined by the Ledger layer and it
depends on the current era at the tip of the chain. The Ledger layer provides
mechanisms to translate transactions from older eras to more recent ones. The
original transaction is the one that will be forwarded to other peers, i.e. the
"translated" version of the transaction _is not sent_ over the network.

> [!NOTE]
>
> In order to prevent overusing resources, the Ledger places a limit on the
> number of pending transactions it accepts on a single block, which should be
> enforced by the mempool. Once this limit is reached, requests to add new
> transactions will be rejected. This _back-pressure_ mechanism is critically
> important in periods of intense traffic to preserve the overall throughput of
> the network.
>
> This limit is not defined as a raw number of transactions but as a cap on
> various metrics, currently transaction size in bytes, execution units in CPU
> and Memory units.

## Fairness

> [!WARNING]
>
> TODO: describe fairness and what should mempools do in this regard.
