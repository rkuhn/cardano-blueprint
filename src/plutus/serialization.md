# Serialization

## Serializing Data Objects Using the CBOR Format

`Data` is a Plutus Core built-in type.
It is used for on-chain data interchange, such as arguments to Plutus validators.
The following is the Haskell definition of `Data`:

```haskell
data Data =
  Constr Integer [Data]
  | Map [(Data, Data)]
  | List [Data]
  | I Integer
  | B ByteString
```

Because blockchains store and transmit data in binary format, a `Data` object must be serialized into bytes whenever it is included in a transaction, or stored in a UTxO.
The serialization method must be deterministic, compact and stable.

Cardano uses CBOR extensively as a serialization format, so CBOR is also used for `Data` objects.
All Cardano node implementations must agree on how `Data` objects are serialized.
The serialization method used by the Haskell node is described in the Plutus Core spec, Appendix B.

## Serializing Plutus Scripts Using the Flat Format

Plutus scripts must also be serialized into a binary format so that they can be stored, transmitted and hashed.

Plutus scripts are serialized using the `flat` format.
`flat` is much more compact and faster than CBOR for serializing programs due to avoiding unnecessary metadata, resulting in a smaller script size and faster serialization - important for on-chain storage and transaction fees.

The `flat`-serialized script is then serialized into CBOR, based on which script hashes are calculated.

All Cardano node implementations must agree on how Plutus scripts are serialized.
The serialization method used by the Haskell node is described in the Plutus Core script, Appendix C.
