# The Header/Body Split in Detail

Upon reading [the original paper on Ouroboros](https://eprint.iacr.org/2016/889.pdf),
or that of [Praos](https://eprint.iacr.org/2017/573.pdf), the reader will discover
only a passing reference to "block headers". Indeed, the original conception of
Ouroboros requires no such distinction - since the theoretical network in which
the mathematical formalism operates is capable of exchanging arbitrarily long
chains within $\Delta$ slots, there is no need for a header/body split. While
headers may play an intrinsic role in Proof of Work protocols, which are
capable of validating _eligibility to issue a block_ without reference to the
underlying ledger state, a Proof of Stake system requires access to that stake
to validate leadership proofs. Conceptually, then, a Proof of Stake system may
require full knowledge of the state at slot $n - 1$ in order to validate block
$n$.

The header/body split arises (as do many other important details) from the need
to reconcile the original Ouroboros description with the reality of working in
a real world setting, with constraints on memory, CPU, and network bandwidth.

The general idea behind the header/body split is as such:

1. Headers remain small. This helps in a few ways:
  a. A header can be sent inside a single TCP packet. This significantly
      reduces the overhead involved and the transmission latency.
  b. A node may simultaneously process and store headers from multiple upstream
      peers.
2. A header may be validated with reference only to some _suitably recent_
    ledger state.
3. Chain selection, the process by which we choose the "correct" chain to
    follow and build our own blocks atop of, is carried out entirely by
    reference to headers.

While the full details of header and body processing (in particular, the fact
that they are exchanged via separate protocols, and how consensus operates) are
detailed in the Consensus and Networking sections, we deal below with the
implications of this split on the ledger layer, and what this means for a
node developer.

## Implications of the header/body split

The main implication of the header/body split derives from point (2) above:

>  A header may be validated with reference only to some _suitably recent_ ledger state.

For Cardano mainnet, _suitably recent_ means within $3k/f$ slots, a value we
refer to as the "forecast window" (in early references, such as the Shelley
specification, this was also fixed as being the stability window. The values are
the same, but the two concepts are conceptually different). In real life terms
this equates to around 36 hours. 

In order to guarantee this property, the ledger must ensure that transactions
(the contents of the block body) cannot effect the validity of headers
within this window. To guarantee this, the stake distribution used to determine
leadership elections is not the _current_ stake distribution but a snapshot of
a previous stake distribution. 

The ledger must be responsible for keeping track of the relevant snapshots.
