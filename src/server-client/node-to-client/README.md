# Node-To-Client (NTC)

`cardano-node` implements a set of mini-protocols that follow rules very similar
to those in the Node-To-Node interface, except that they communicate through a
named pipe. As these protocols establish connections to local clients there is
trust between peers and consequently they behave more like traditional
client/server APIs.

In particular, these mini-protocols will also be wrapped by a
[multiplexer](../network/multiplexing.md).

These mini-protocols are:

- [Handshake](handshake): to negotiate the versions used in the connection,
- [LocalTxSubmission](txsubmission2): to submit transactions to the network,
- [LocalStateQuery](state-query/README.md): to query for information about the ledger state,
- [TxMonitor](txmonitor): to monitor the status of transactions,
- [LocalChainSync](chainsync): to retrieve chains of blocks from the node.
