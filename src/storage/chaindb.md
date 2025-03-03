# The ChainDB format

In the Haskell reference implementation, the Storage layer manages a `ChainDB`,
whose storage components are the Immutable Database, Volatile Database and
Ledger State snapshots:

| Component              | Responsibility                                                                                                                                          |
|:-----------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
| Immutable Database     | Store definitive blocks and headers sequentially                                                                                                        |
| Volatile Database      | Store a bag of non-definitive blocks and headers. In particular it contains the blocks which, when linked sequentially, form the current selected chain |
| Ledger State snapshots | Periodically store the ledger state at the tip of the ImmutableDB                                                                                       |

Although this implementation represents just one of many possible data storage
solutions, it is the one used by the reference `cardano-node` implementation and
has become the de-facto standard for distributing the Cardano chain when the
node is not involved. Consequently, services like Mithril sign this directory
structure and its format.

It consists of 3 separate directories in which different data is stored:

```
db
├── immutable
│   ├── 00000.chunk
│   ├── 00000.primary
│   ├── 00000.secondary
│   └── ...
├── ledger
│   └── 164021355
└── volatile
    ├── blocks-0.dat
    └── ...
```

This diagram depicts where the blocks are distributed in such directories:

```mermaid
flowchart RL
    subgraph volatile;
      subgraph "current selection";
        Tip -->|...| Km1["(k-1)-th Block"]
        Km1 --> K["k-th Block"]
      end

      O1["Block"] --> O2["Block"]
      O3["Block"] --> K

      O4["Block"]
    end

    subgraph immutable;
     subgraph "Chunk 0";
        C0[" "]
        C1[" "] --> C0
        C2[" "] -->|...| C1
     end
     subgraph "Chunk 1";
        D0[" "]
        D1[" "] --> D0
        D2[" "] -->|...| D1
     end

     D0 --> C2
     subgraph "Chunk n";
     Kp1["(k+1)-th Block"] --> Kp2["(k+2)-th Block"]
     Kp2["(k+2)-th Block"] --> |...| E0[" "]
     end

     E0 -->|...| D2
    end
    K --> Kp1
    C0 --> Genesis
    subgraph ledger;
     S["Persisted snapshot"] --> Kp1
    end
```

## `immutable`

Contains the historical chain of blocks.

TODO explain NestedCtxt, Header, Block, the Hard Fork Block, chunks, primary and secondary indices.

## `volatile`

Contains blocks that form the current selection of the node (i.e. the best chain
it knows about) and other blocks (both connected or disconnected from the
selected chain) but whose slot number is greater than the `k`-th block in the
current selection (so they might belong to a fork less than `k` blocks deep).

TODO describe the format in which the blocks are stored

## `ledger`

Contains ledger state snapshots at immutable blocks. Ideally, this is the most
recent immutable block, but since snapshots are taken periodically (due to their
cost), it may be an older block. Snapshots are named after the slot number of
the block when they were taken.

The snapshot is a file containing a CBOR-encoded Extended Ledger State. The
_Extended Ledger State_ is a combination of the Chain State (used by the
protocol used in such era) and the Ledger State.

Coming soon: UTxO-HD
