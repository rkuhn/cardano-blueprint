# Mini-protocols

Mini-protocols are extensively described in other sections of the
Blueprint. This section aggregates the technical reference for them,
containing also the CDDL specifications.

Mandatory mini-protocols that need to be implemented to fully
participate in the Cardano network are the Node-To-Node (NTN)
mini-protocols which currently define version 14 of the Node-To-Node
combined protocol:

- [ChainSync](node-to-node/v14/chainsync.md)
- [BlockFetch](node-to-node/v14/blockfetch.md)
- [TxSubmission2](node-to-node/v14/txsubmission2.md)
- [KeepAlive](node-to-node/v14/keep-alive.md)
- [PeerSharing](node-to-node/v14/peer-sharing.md)
- [Handshake](node-to-node/v14/handshake.md)

In addition, we describe the `cardano-node` Node-To-Client (NTC)
mini-protocols which are not mandatory to be implemented in a
node.

> [!NOTE]
> Other implementations might choose to use a different way to
> interact with clients, but as there exists interest for either
> building new clients for the `cardano-node` or reuse clients
> originally intended to be used with the `cardano-node` in other
> implementations, the decision was to gather this information also in
> the Blueprints.

These mini-protocols are:

- [LocalTxSubmission](cardano-node/node-to-client/txsubmission2.md)
- [LocalStateQuery](cardano-node/node-to-client/local-state-query.md)
- [TxMonitor](cardano-node/node-to-client/txmonitor.md)
- [LocalChainSync](cardano-node/node-to-client/localchainsync.md)
- [Handshake](cardano-node/node-to-client/handshake.md)
