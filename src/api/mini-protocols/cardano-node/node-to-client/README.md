# Node-To-Client (NTC)

A cardano node may offer a client-facing API using the [network protocols](../network). This interface is slightly different than the Node-to-Node (N2N) style of communication as there is trust between peers and consequently behaves more like traditional client/server APIs.

This document serves as concrete API reference for the various NTC protocols and currently only covers the local state query API.

> [!NOTE]
> The way to establish connections to an N2C server may differ from one implementation to another. The following sections assume that you have an established connection and negotiated a protocol version possibly through the [handshake protocol](../network/handshake.md).
