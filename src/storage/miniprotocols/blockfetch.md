# BlockFetch

`BlockFetch` is the mini-protocol in charge of diffusing block
bodies. It is a pull-based mini-protocol: data is transmitted only upon
explicit request from the client.

> [!TIP]
>
> There is usually one `BlockFetch` client per peer which is the one
> in charge of exchanging the messages, but `BlockFetch` is
> orchestrated by a central decision component in order to minimise
> network usage by fetching blocks on-demand from a single peer and
> avoid duplicated requests.

Received blocks are then given to the [chain
selection](../consensus/chainsel.md) logic to determine their
[validity](../consensus/chainvalid.md) and, depending on the chain selection
outcome, may be incorporated into the currently selected chain.

If the peer misbehaves, the connection will be abruptly
terminated. Actions that are considered misbehaving are (not exclusively):

- The peer violates the state machine of the protocol,
- The server provided blocks that the client did not request,
- The server sends a block that does not match the header it was supposed to match,
- The server sends a block with a valid header but an invalid body.

> [!WARNING]
>
> TODO: Make this list exhaustive

The specification of the state machine of `BlockFetch` is described in the
Network documentation
([design](https://ouroboros-network.cardano.intersectmbo.org/pdfs/network-design/network-design.pdf)
and
[spec](https://ouroboros-network.cardano.intersectmbo.org/pdfs/network-spec/network-spec.pdf)).


## Access pattern of `BlockFetch`

The requests for blocks involve sequential portions of the chain, whether in the
immutable part or the volatile part of the chain.

The only special case being when a block has become immutable due to the current
chain selection growing in length. In such case the abstraction used to iterate
over the blocks has to be able to find the block which now would live in the
immutable storage.

## Codecs

The blocks sent through `BlockFetch` on the Cardano network are tagged
with the index of the era they belong to. The serialization of the
block proper is its CBOR-in-CBOR representation.

```
serialise block = <era tag><cbor-in-cbor of block>
```
