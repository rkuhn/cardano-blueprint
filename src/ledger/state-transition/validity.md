# Transaction Validity

What does it mean for a transaction to be valid? The ledger specs define it
quite simply: a transaction is valid if it may be applied to a valid ledger
state to return another valid ledger state. We say that it is valid with regard
to the initial ledger state.

More prosaically, for a transaction to be valid with regards to a ledger state
entails the things we would expect: its inputs must exist, the spender must have
the right to spend those inputs, the transaction must balance etc. In the
ledger specifications, these are all written as _predicates_ - assertions that
one thing equals another, for example. A failing predicate means that the
transition is invalid and hence that the transaction is invalid with regard
to that ledger state.

## Multi-phase Validity

Invalid transactions do not end up on the chain. Consequently, invalid
transactions do not pay fees. A trivial attack on a block producing node would
be to bombard it with invalid transactions. The node must verify that each
transaction is invalid, but gains no benefit for performing this work.

In order that this not become an asymmetric resource attack, the work which
must be done to validate a transaction needs be bounded. The introduction of
Plutus in the Alonzo era, however, complicated this situation. Plutus scripts
must necessarily be capable of performing a significant amount of work. Should
this work result in the transaction being deemed invalid, that work would be
uncompensated - an attacker could use relatively small amounts of their own
resource (crafting a looping Plutus script is, after all, relatively easy) to
force significantly larger resource expenditure from the network.

In order to combat this, Alonzo introduced the concept of 2-phase validity:

1. The first phase involves the regular checks of things such as transaction
    size, fee suitability, input validity etc. These checks are assumed to have
    bounded work. A failure in phase 1 indicates that the transaction will
    not be placed on chain.
2. Phase 2 checks are only run if phase 1 succeeds. Phase 2 checks involve
    running Plutus scripts and validating that inputs locked by those scripts
    can be spent. A transaction failing a phase 2 check can still be put on
    chain. In this case, a special input called the 'collateral' is spent and
    donated to the fee pot. The collateral must be locked by a phase-1
    verifiable input - i.e. an input locked by a VKey or native script.

An important consideration is that phase-2 checks are _static_ (see below).
Phase-2 checks are run always in the context only of the transaction and its
resolved inputs (which, since we have a UTxO system, are determinstic if they
exist). As such, a diligent transaction submitter should have no risk of their
collateral being taken - they can validate that their script passes before
submitting the transaction and then be assured that it will either pass when
the transaction is included, or that the transaction will fail during phase 1
(for example, if an input has been spent).[^1]

## Static vs Dynamic Checks

Since transaction validity is defined with regard to a ledger state, a change
to the ledger state may result in previously valid transactions now becoming
invalid. For example, the time may have moved past the transaction's validity
window, or one of the inputs may have been spent.

Consequently, as the ledger state evolves due to new blocks being accepted,
nodes need to revalidate transactions in their mempool against the new state.
However, not everything needs to be revalidated. Cryptographic signatures, for
example, are guaranteed to remain valid regardless of the ledger state.

Formally, we call a check _static_ if it can be evaluated with regard only to
the contents of the transaction and its resolved inputs. Examples
(non-exhaustive) of static checks include:

- Cryptographic signature checks
- Native (multisig/timelock) scripts
- Phase 2 checks (Plutus scripts)

_Dynamic checks_, on the other hand, require access to the UTxO or other aspects
of the ledger state to compute. As such, they need to be re-evaluated each time
the ledger state is updated. Obvious examples of dynamic checks include
verifying that inputs exist, checking that the transaction still sits within its
validity window, and validating block transaction size against the protocol
parameters.

# Block Validity

> This section is currently a stub

# Relevance for the node developer

The above is mostly relevant for node developers in that it is useful to be able
to run the ledger transitions with fine-grained control over which checks are
computed.

There are four main scenarios which come into consideration:

1. Validating a transaction as it enters the mempool. In this case all checks
  must be computed.
2. Re-validating a transaction after a new block has been adopted. In this case,
  we care only about re-running _dynamic_ checks.
3. Validating a new block body downloaded from a peer. In this case all checks
  must be computed.
4. Re-applying a block from our local storage in order to reconstruct the ledger
  state. Since local blocks are assumed to be trusted, we need run _no_ checks
  here and only apply the transition.

Node developers should bear these scenarios in mind when considering how to
structure their node transition function.

[^1]: Note that there is a small addendum to this story. While theoretically
anyone may validate their own Plutus scripts, many users do not run their own
node and as such trust a third party to validate those scripts on their behalf.
These users were concerned about accidentally losing collateral. Since
collateral must be a single address, users in such a situation either had to
assign precisely the 'minCollateral' to an address or put up another UTxO as
collateral and risk losing more than the minimum. To assuage the fears of such
folks, Babbage introduced a 'collateral return address' to which collateral in
excess of the minimum required would be returned in the case of a failing
script.
