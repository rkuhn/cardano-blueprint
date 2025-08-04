# Client interfaces

Node implementations may offer interfaces to clients for submitting new data to
the network (transactions) as well as query data from the node. The spectrum of
protocols that could serve this purpose is open and the choice is free for each
implementation. Here we aggregate some interfaces that have been implemented for
enabling this interaction:

- the [Node-To-Client (NTC)](./node-to-client/) interface as introduced by [cardano-node], which is very similar to the Node-To-Node (NTN) [network](../network) protocols,
- the [UTxO RPC](utxo-rpc/README.md) interface as a standard interface shared
  with other UTxO-based blockchains.

Below we present a table with clients and servers that implement each protocol:

| Server         | NTC | UTxO RPC |
| :------------- | --- | -------- |
| [cardano-node] | ✅  | ❔       |
| [dingo]        | ✅  | ✅       |
| [amaru]        | ❔  | ❔       |

<br/>

| Client        | NTC | UTxO RPC |
| :------------ | --- | -------- |
| [cardano-cli] | ✅  | ⬜       |
| [pallas]      | ✅  | ❔       |
| [gouroboros]  | ✅  | ❔       |

> [!NOTE]
>
> Please help us keep this list up-to-date by [suggesting an edit](https://github.com/cardano-scaling/cardano-blueprint/edit/main/src/client/README.md).

[amaru]: https://github.com/pragma-org/amaru/
[cardano-cli]: https://github.com/IntersectMBO/cardano-cli
[cardano-node]: https://github.com/IntersectMBO/cardano-node
[dingo]: https://github.com/blinklabs-io/dingo
[gouroboros]: https://github.com/blinklabs-io/gouroboros
[pallas]: https://github.com/txpipe/pallas
