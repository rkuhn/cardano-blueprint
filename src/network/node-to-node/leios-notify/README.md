# LeiosNotify

**Mini-protocol number: 18**

> [!WARNING]
>
> This protocol is **proposed** and not yet part of the Cardano mainnet. It is
> specified as part of [Leios (CIP-0164)](https://github.com/cardano-foundation/CIPs/pull/1167),
> an extension to the Ouroboros consensus protocol aimed at significantly
> increasing transaction throughput. Details are subject to change.

`LeiosNotify` is the mini-protocol responsible for announcing Endorser Blocks
(EBs) and offering EB bodies and their associated transaction closures to peers.
It is a pull-based protocol: the client drives progress by requesting the next
notification, and the server replies with whatever is available.

Leios introduces Endorser Blocks as a mechanism to endorse and achieve consensus
on transaction inclusion independently and overlayed on the Praos block chain.
`LeiosNotify` is the dissemination layer that lets peers discover new EBs before
fetching them via [LeiosFetch](../leios-fetch/README.md). The protocol is
intended to run in a pipelined fashion where the client issues multiple
`MsgRequestNext` even before receiving a notification, so that the server can
push announcements to downstream peers with minimal latency.

> [!WARNING]
>
> TODO: Add more detail about admitted pipeline depth and other punishable requirements 

## State machine

```mermaid
stateDiagram
   direction LR
   [*] --> StIdle
   StIdle --> [*]: MsgClientDone
   StIdle --> StBusy: MsgRequestNext
   StBusy --> StIdle: MsgBlockAnnouncement
   StBusy --> StIdle: MsgBlockOffer
   StBusy --> StIdle: MsgBlockTxsOffer

    classDef initiator color:#080
    classDef responder color:#008, text-decoration: underline
    class StIdle initiator
    class StBusy responder
```

### State agencies

| State  | Agency                                                              |
| :----- | :------------------------------------------------------------------ |
| StIdle | <span style="color:#080">Initiator</span>                           |
| StBusy | <span style="color:#008;text-decoration:underline">Responder</span> |

### State transitions

| From state | Message              | Parameters              | To state |
| :--------- | :------------------- | ----------------------- | :------- |
| StIdle     | MsgClientDone        |                         | End      |
| StIdle     | MsgRequestNext       |                         | StBusy   |
| StBusy     | MsgBlockAnnouncement | `announcement`          | StIdle   |
| StBusy     | MsgBlockOffer        | `point`, `size`         | StIdle   |
| StBusy     | MsgBlockTxsOffer     | `point`                 | StIdle   |

## Codecs

The messages depicted in the state machine follow this CDDL specification:

```cddl
;; messages.cddl
{{#include messages.cddl}}
```
