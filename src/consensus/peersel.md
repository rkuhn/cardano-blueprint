# Peer Selection

The Cardano node receives chain updates from upstream peers and forwards chain
updates to downstream peers. While the downstream behaviour can only be switched
on or off (by accepting connections or not), the upstream behaviour depends on
actively establishing connections to other peers. There are two basic ways in
which this is configured:

- a static configuration lists known peers by DNS name or IP address and port
- a dynamic configuration states how many peers to connect to, with peers being
  discovered either through the ledger or through the
  [peer sharing](../network/node-to-node/peer-sharing) protocol.

> [!WARNING]
> This section is far from complete, below is an evolving sketch of its future
> contents

## Safety considerations

In general, a Cardano node with fully dynamic peer selection is vulnerable to
eclipse attacks (being nudged by malicious peers into connecting only to
malicious peers). A solution to this problem has been formulated in the
[Ouroboros Genesis paper](https://iohk.io/en/research/library/papers/ouroboros-genesis-composable-proof-of-stake-blockchains-with-dynamic-availability/).

A statically configured node can avoid these issues by having a fixed
connection to at least one known honest peer.

## Common setups

A block producer run by a diligent stake pool operator will have a completely
static configuration that connects it to its designated relay nodes only.
Relay nodes typically supplement dynamic selection with some static
configuration that at least sets up the connections to their respective block
producer. Data nodes may choose any combination of static and dynamic
configuration.

## Dynamic peer selection process

At a roughly hourly schedule, the node should replace the bottom 20% of its
peers with randomly selected new ones. The interval should be randomized to
avoid the whole network synchronizing on this schedule, which would impair
performance at this time. The ranking for determining which nodes to replace
should be linked to honesty chain update performance: the first peer to
announce a correct and new block should be rewarded. It may be that rewarding
the second and third makes sense as well, although that is not currently done
by the Haskell implementation.

Before choosing the above strategy the expected outcomes on a whole network
level have been simulated. The churn rate of 20% per hour has been selected
based on the simulation outcomes — anecdotally, the choice of 40%/h might lead
to the network falling apart into multiple disconnected pieces. This note is
left here as a cautionary tale that changing this strategy will require
stringent analysis.
