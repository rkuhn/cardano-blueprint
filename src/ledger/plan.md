# Ledger Blueprint Planning

The aim is to restructure this documentation with the aim of providing a guide
to somebody who might wish to implement the ledger for a compatible node.

To that end, we break down the documentation in various sections. Certain
things make sense to document in certain ways. We wish to avoid any duplication
of work already done - for example, the formal specs remain probably the best
way to document the precise implementation of a pure function. However, we can
provide guidance for people trying to read the specifications.

It is the fundamental nature of documentation to go out of date. As such, we
also want to avoid referring to details of specific eras etc (which are in any
case covered in the formal specs) and instead cover the general principles and
details needed by all potential implementations.

- Concepts
  - [x] Blocks
    - The header/body split
  - Transactions
  - Eras
  - The structure of an epoch
  - Determinism
- The ledger state transition
  - [x] How to read the specs
    - Old-style semi-formal specs
    - New-style Agda specifications
  - [x] Validity
    - [x] Multi-phase validity
    - [x] Static vs dynamic checks
- Ledger interfaces
  - To the consensus layer
    - Applying a block
    - Ticking
      - On an era boundary
    - Forecasting
    - Nonces
    - The stake distribution
  - To the mempool
    - Validating a transaction
    - Revalidating a transaction
  - To the CLI
    - Forecasting the leader schedule
- Understanding parts of the transition
  - Non-integral math
  - Transaction fee calculation
  - Reward calculation
- Ledger serialisation
  - Transaction and block formats
  - The ledger state
    - Decomposition - large and small parts
  - Non-canonical serialisation
- Constraints on the ledger
  - Computational concerns
    - Avoiding spikes
  - Implications of the header/body split
  - Rollbacks and storage
