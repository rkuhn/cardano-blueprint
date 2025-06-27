# Witness Validation

TODO: provide a description of the ledger rules relevant to this domain specific concept.

## Footgun #1: Bootstrap Witnesses
Alonzo introduced a [`bootstrap_witness`](https://github.com/IntersectMBO/cardano-ledger/blob/d71d7923a79cfcde8cac0b5db399a5427524d06a/eras/allegra/impl/cddl-files/allegra.cddl#L314-L319), which is a different structure for witnesses from a bootstrap address. One would, perhaps reasonably, assume that all witnesses from bootstrap addresses would be provided in this list. However, that is not an assumption that can be made.

### Example: `0c22edee0ffd7c8f32d2fe4da1f144e9ef78dfb51e1678d5198493a83d6cf8ec`
Consider the following [transaction](https://preprod.cexplorer.io/tx/0c22edee0ffd7c8f32d2fe4da1f144e9ef78dfb51e1678d5198493a83d6cf8ec) on Preprod. In JSON, it looks like this:
```json
{
  "id": "0c22edee0ffd7c8f32d2fe4da1f144e9ef78dfb51e1678d5198493a83d6cf8ec",
  "spends": "inputs",
  "inputs": [
    {
      "transaction": {
        "id": "4a0f0fd2ea2e91b34065e3085448b211afdcf72f9db0b2d74d1f99246e16c860"
      },
      "index": 1
    },
    {
      "transaction": {
        "id": "9157ee358b91c319a2e9dd087fe612d1c3d72d34fa4104bec13c8d37fd40b854"
      },
      "index": 1
    }
  ],
  "outputs": [
    {
      "address": "FHnt4NL7yPXtiYgxWx33wH6JXA9cYxzGAgVG1iMmaX9muBogARkHTRkUox4g4aR",
      "value": {
        "ada": {
          "lovelace": 4832251
        }
      }
    },
    {
      "address": "addr_test1vpfnhjud440uspylt4pewj7uy8tr0adh84sjqgmnq09xssca7lf4g",
      "value": {
        "ada": {
          "lovelace": 5000000
        }
      }
    }
  ],
  "fee": {
    "ada": {
      "lovelace": 167749
    }
  },
  "validityInterval": {},
  "treasury": {},
  "signatories": [
    {
      "key": "b1ef2a278ebe7cfd563c30f1bb642fb6b5616e040792527e6cd58f119895d657",
      "signature": "4110259fb4433f462512d6fa69958070f9e365831962744e7e2e7a2f6a721a707ec4f213ff736fcc195490254dc9d22e0fe0552ae1781b965fc4d05bd5ebb304"
    }
  ],
  "cbor": "84a300828258204a0f0fd2ea2e91b34065e3085448b211afdcf72f9db0b2d74d1f99246e16c860018258209157ee358b91c319a2e9dd087fe612d1c3d72d34fa4104bec13c8d37fd40b85401018282582e82d818582483581c533bcb8dad5fc8049f5d43974bdc21d637f5b73d6120237303ca6843a1024101001a63bbc5a61a0049bbfb82581d60533bcb8dad5fc8049f5d43974bdc21d637f5b73d6120237303ca68431a004c4b40021a00028f45a10081825820b1ef2a278ebe7cfd563c30f1bb642fb6b5616e040792527e6cd58f119895d65758404110259fb4433f462512d6fa69958070f9e365831962744e7e2e7a2f6a721a707ec4f213ff736fcc195490254dc9d22e0fe0552ae1781b965fc4d05bd5ebb304f5f6"
}
```

Notably, there is only one signature, and it is not in the form of a bootstrap witness. If we look at the logic that collects vkey hashes that must be present in the witness set ([`getShelleyWitsVkeyNeededNoGov`](https://github.com/IntersectMBO/cardano-ledger/blob/d71d7923a79cfcde8cac0b5db399a5427524d06a/eras/shelley/impl/src/Cardano/Ledger/Shelley/UTxO.hs#L226-L249)), we can understand why.
```hs
inputAuthors :: Set (KeyHash 'Witness)
inputAuthors = foldr' accum Set.empty (txBody ^. spendableInputsTxBodyF)
  where
    accum txin !ans =
      case txinLookup txin utxo' of
        Just txOut ->
          case txOut ^. addrTxOutL of
            Addr _ (KeyHashObj pay) _ -> Set.insert (asWitness pay) ans
            AddrBootstrap bootAddr ->
              Set.insert (asWitness (bootstrapKeyHash bootAddr)) ans
            _ -> ans
        Nothing -> ans
```

Bootstrap witnesses and vkey witnesses are combined in the same set, since they are both just hash digests of the same size. That means, if one were to construct a bootstrap address with a payload containing only the keyhash, the validation would pass with a regular vkey witness, instead of a bootstrap witness.

The witnesses themselves are valdiated in isolation–just that they are valid signatures on the required data–so the presence of a boostrap address does not necessarily require the presence of a bootstrap witness.
