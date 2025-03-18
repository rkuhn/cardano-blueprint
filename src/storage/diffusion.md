# Semantics of storage mini-protocols

The mathematical model of the Ouroboros Consensus Protocols assumes
instantaneous transmission (and validation) of chains, becoming instantly
available even for newly joined peers. This is, even if just because of physical
real-world limitations, infeasible in practice. For this reason, transmission of
chains is done in a block-by-block basis instead. This allows chains to be
incrementally sent to peers but comes with its own risks for newly joined peers
(see [Ouroboros Genesis](../consensus/chainsel.md#ouroboros-genesis)).

Furthermore, blocks (which in the end is the data transmitted over the network)
are subdivided in block headers and block bodies, as described in the
[Header|body split](../consensus/#headerbody-split) section.

The diffusion of data in the Cardano network is in fact a responsibility of the
[Networking layer](../network). The diffusion of chains involves accessing the
Storage layer and serving its contents to peers, however it is ultimately the
[Consensus layer](../consensus/) the one that decides how the data in the
Storage layer is mutated, as an outcome of [Chain
Selection](../consensus/chainsel.md).

> Chain diffusion is a joint effort of the Consensus, Network and Storage
> layers.

Diffusion of chains is achieved by means of
[`ChainSync`](./miniprotocols/chainsync.md) and
[`BlockFetch`](./miniprotocols/blockfetch.md) mini-protocols.

In a sense, the Storage layer has the data to provide the meaning of the
messages in the mini-protocol whereas the networking layer describes the kinds
of messages a protocol is composed by. It is possible to run an interaction of
the protocol exchanging data that does not follow the intended semantics (for
example an evil node sending all the chains it knows about instead of only the
best selection). That's why we describe here when each message should be emitted
and what information it should carry.
