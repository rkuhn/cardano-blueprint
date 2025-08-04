# Forging new blocks

Forging new blocks is the process of packing data that has not yet been included
in the blockchain (pending transactions) into a fresh block. Blocks are signed
by stake pool credentials, so only the nodes which are configured with such
credentials would be able to forge blocks and therefore only those nodes are
strictly need to implement the forging mechanism.

## Forging

Every slot, the stake pool (whose keys the node was configured with) might be
entitled to produce a block, depending on the rules of the particular Protocol
that is running at the tip of the current chain. For Praos on the current chain
on mainnet, slots have a duration of one second. The probability of a node being
elected in a slot is controlled via the _active slot coefficient_ parameter
(commonly referred to as `f`) which on mainnet is `0.05`. This means that a
block is expected once every 20 slots on average.

Forging a block would look something similar to the following sequence of
actions:

1. Determine whether my stake pool is entitled to create a block on
   this slot. Below we describe what this means in Ouroboros Praos. We
   omit the details for other protocols as they do not produce blocks
   anymore on Cardano mainnet.
1. Acquire a data to constitute the body of a block. Consensus is theoretically
   unaware of what data makes up the block body, and it will be the
   [Mempool](../mempool) the one that specifies which data is valid and provides
   such data.
1. Pack the data into a block body, produce a block header and emit a signature.

Note that it is in the interest of the stake pool (so that its block is included
in the chain) and of the network as a whole (so that the chain grows) that the
process of creating a block is as fast as possible while still producing a fully
valid block.

> [!TIP]
>
> To ensure the new block is actually valid, it could be fed into the [Chain
> Selection](./chainsel.md) logic, which is expected to select it and then
> [diffuse](../storage/#chain-diffusion) it via the usual mechanisms. This sanity
> check is not a hard requirement but it is advised to be implemented. If not
> even the node that created the block can adopt it, sending such block to the
> network would be useless.

## Multi-leader slots

There exists the possibility of multiple stake pools being elected in the same
slot. If the nodes of both pools produce blocks, a momentary fork will exist in
the chain, which we call a _slot battle_. Ouroboros Praos guarantees that only
one of those blocks will end up in the honest chain, and that such a fork will
not survive more than the time it will take for either of the candidates to grow
to `k` blocks.

Two stake pools might be elected in very close slots, which implies that if the
block of the first stake pool doesn't arrive at the node of the second stake
pool on time, it will not be considered when the second node forges its block,
creating another short-lived fork. This situation is called a _height
battle_. To avoid this situation, it is of utmost importance that the forging of
a block and its diffusion through the network (first its header via ChainSync,
then its body via BlockFetch) is as fast as possible.

## Leadership check in Ouroboros Praos

In Ouroboros Praos, the stake distribution is what dictates the elegibility of
an stake pool for being elected. The probability of a stake pool $U_i$ with
relative stake $\alpha_i$ being elected as slot leader comes from this formula:

$$p_i = \phi{}_f(\alpha_i) = 1 - (1 - f)^{\alpha_i}$$

Some important properties are ensured by Praos:

- There can be multiple slot leaders as the events "$U_i$ is a leader for slot
  `sl`" are independent,
- There can be slots with no leader,
- Only a slot leader is aware that it is indeed a leader for a given slot,
- The probability of being a slot leader is independent of whether the stake
  pool acts as a single party or splits it stake among several "virtual"
  parties.

> [!WARNING]
>
> TODO should probably discuss the leadership schedule, how can one know it in
> advance, the stability periods, the parts of the epoch, which distribution is
> used (2 epochs ago?)
