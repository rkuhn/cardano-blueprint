# Server/Client interfaces

Node implementations need some interface with clients for submitting new data to
the network (transactions) as well as query data from the node. The spectrum of
protocols that could serve this purpose is open and the choice is free for each
implementation. Here we aggregate some interfaces that have been implemented for
enabling this interaction:

- `cardano-node` implements the [Node-To-Client](./node-to-client/)
  interface, leveraging the existing Node-To-Node interface,
- the [UTxO RPC](utxo-rpc/README.md) interface as a standard interface shared
  with other UTxO-based blockchains.

Below we present a table with clients and servers that implement each protocol:

| Server         | NTC | UTxO RPC |
|:---------------|-----|----------|
| `cardano-node` | ✅  | ❔       |
| `dingo`        | ✅  | ❔       |
| `amaru`        | ❔  | ❔       |


| Client         | NTC | UTxO RPC |
|:---------------|-----|----------|
| `cardano-cli`  | ✅  | ❔       |

> [!NOTE]
>
> Should you want to change the table above in any way, please submit a PR to
> [the Blueprints
> repository](https://github.com/cardano-scaling/cardano-blueprint).
