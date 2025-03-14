# Transaction fee

> [!WARNING]
> Ideally this would not exist in a vacuum and instead benefit from a general explanation on Cardano transactions.

> [!NOTE]
> This file is hand-written and currently not checked for correctness. The domain is very small and hence this would make for a great testing ground for techniques to ensure consistent, but also approachable documentation.

This is a write-up of how transaction fees are calculated. In fact, the minimum transaction fee for transaction to be deemed valid by the Cardano ledger.

This document describes the situation as of
- Protocol version: `10`
- Era: `Conway`

See also:

- Formal ledger specification: [Alonzo, Figure 4, minfee](file:///home/ch1bo/Downloads/alonzo-ledger-2.pdf) and [Conway, chapter 4](https://intersectmbo.github.io/formal-ledger-specifications/pdfs/conway-ledger.pdf#section.4)
- Haskell implementation: [getConwayMinFeeTxUtxo](https://github.com/input-output-hk/cardano-ledger/blob/f0a0864eab00cd269befcdcd1931250dbb329f80/eras/conway/impl/src/Cardano/Ledger/Conway/UTxO.hs#L138) and releated functions

## Inputs
 - Transaction bytes, CBOR-encoded
 - Resolved inputs (= unspent outputs), CBOR-encoded
 - Protocol Parameters
   - `minFeeConstant`
   - `minFeeCoefficient`
   - `minFeeReferenceScripts`
   - `prices.memory`
   - `prices.steps`

> [!WARNING]
> TODO: Include transaction CDDL to reference individual parts (e.g. transaction_output)
> TODO: Explain protocol parameters somewhere

## Algorithm

At a high level, the fee is composed of
- a minimum constant,
- plus a cost per transaction byte,
- plus a cost per reference script byte,
- plus an execution cost per budgeted script redeemer.

Calculate the base fee by adding the `minFeeConstant` to (`minFeeCoefficient` * serialized transaction length in bytes). These numbers are all integers, so you shouldn't end up with a fractional amount of lovelace.

> [!WARNING]
> TODO: Explain resolving input and reference inputs

Next, calculate the untagged size of each `scriptRef` on each of the transaction inputs and reference inputs. Specifically, each `scriptRef` field is serialized as a cbor tag, an integer plutus version, and then the raw script bytes. We're interested in the size of the raw script bytes only.

Next, calculate the reference script fee. First, sum up the length in bytes of each of script reference into `scriptRefLengths`. The `minFeeReferenceScripts` parameter consists of a `base`, a `multiplier`, and a `range`. (Note that in conway, the multiplier and the range are hard coded, rather than protocol parameters, but the intention is to change this at the next hardfork.)

To calculate the fee, starting from a `baseFee` of `minFeeReferenceScripts.base` and remaining bytes of `sum(scriptRefLengths)`, until remaining bytes is zero, add `baseFee * min(remainingBytes, minFeeReferenceScripts.range)`, scale `baseFee` by `minFeeReferenceScripts.multiplier`, and decrease `remainingBytes` by `min(remainingBytes, minFeeReferenceScripts.range)`. This calculation can result in rational values (as the multiplier can be rational), and so you should take the ceiling as a *last step*.

Finally, to calculate the evaluation fee, for each redeemer, multiply the redeemer execution units budget (memory and steps) by the corresponding protocol paramters (`prices.memory` and `prices.steps`), and add them up. These are fractional parameters, so you may end with a fractional amount of lovelace, and you should take the ceiling.

The final minimum fee is the base fee, plus the reference script fee, plus the evaluation fee.

## Example

Lets do a decently complex worked example, from mainnet transaction with id (body hash)

`f06e17af7b0085b44bcc13f76008202c69865795841c692875810bc92948d609`

The transaction bytes are:
```hex
84ac00838258209ea0d817dc67ce8046f6c2abc27267905c74374530c4684bb3c252ed6b97cc8702825820e3195e7888a83f3d1ef218e50675bfa10d9817a4a756b8ba26305f604c0f96e500825820285c77a9e62c0f87fedfcc91a630251ce2b7fcb9dd8d2fd8591c0d0aba46d4bc000183a300583911e0302560ced2fdcbfcb2602697df970cd0d6a38f94b32703f51c312bbc10fe312acd69e2e12cbc2cca05aa0e432e3dee65d5a9498344e4aa01821b00000082deef6e00a2581c5d16cc1a177b5d9ba9cfa9793b07e60f1fb70fea1f8aef064415d114a1434941471b0000016f8a787b24581ce0302560ced2fdcbfcb2602697df970cd0d6a38f94b32703f51c312ba15820000de1406f79e3e55eef82b9d03cf62cc3d4a6d0d03b00bf7b1b43330f82977901028201d8185862d8799f581c6f79e3e55eef82b9d03cf62cc3d4a6d0d03b00bf7b1b43330f8297799f9f4040ff9f581c5d16cc1a177b5d9ba9cfa9793b07e60f1fb70fea1f8aef064415d11443494147ffff1b000000c823a3f15c18641864d87a80001a73c3be00ff8258390123a9f67af7e7e6d1aa0b495f68787649bb6f097d6648c2fa59c185e400168e1b0b38fe76f31427ee638adba1b7ad61ab8274ff4ecaa4109e821a001e8480a1581c5d16cc1a177b5d9ba9cfa9793b07e60f1fb70fea1f8aef064415d114a1434941471afad8cc9182581d618ca0e08cdbc30fa0dd21833d7370d666493ecc28b136df179f97fb5d1a6079b955021a00092e4d031a08e498d705a1581df199e5aacf401fed0eb0e2993d72d423947f42342e8f848353d03efe6100081a08e491070b5820b159feadc14235013a7ac8e993b410e5cdbd69c5829cd06b463603f15a39e6660d818258209ea0d817dc67ce8046f6c2abc27267905c74374530c4684bb3c252ed6b97cc87020e81581c8ca0e08cdbc30fa0dd21833d7370d666493ecc28b136df179f97fb5d1082581d618ca0e08cdbc30fa0dd21833d7370d666493ecc28b136df179f97fb5d1a60369c62111a004c4b401283825820fa46a1d162c59cece3308c5a9d4db9ff2ea17f9c0146ff821c9b445588b017c900825820f5f1bdfad3eb4d67d2fc36f36f47fc2938cf6f001689184ab320735a28642cf2008258200258ec397cbd4a86951126bd2c423d62f71ec844430964cd0e14df2f951906a400a3008182582043be65bfb94286317d1274ff4c1d4890ddc524d04d1182c4c714e97e1985954858401a5d1672aed8d170f343c2d517d8475f3569df6e1db0741091a2fcc3aae92a520b9496e91a005544b8d1ae938525666ba732f8a88945fb8ba859f91b2636ee0706815901455901420100003323232323232322322253330053253330063370e900218039baa300130083754004264a66600e66e1d2000300837540022646600200264a66601266e1d2002300a3754002297adef6c6013756601c60166ea8004c8cc004004dd5980218059baa300e300b375400644a66601a0022980103d87a80001323232533300d3371e0166eb8c03800c4cdd2a4000660226e980052f5c026600a00a0046eacc038008c044008c03c004894ccc030004528099299980519b873371c6eb8c02cc03c00920024806852889980180180098078008b1929998050008a6103d87a800013374a9000198059806000a5eb80dd618059806180618041baa300b3008375400429408c02cc03000452613656375c002ae6955ceaab9e5573eae815d0aba24c011e581ce0302560ced2fdcbfcb2602697df970cd0d6a38f94b32703f51c312b00010583840000d87a9fd8799f000d9f9f02d87a8000ffffffff821a001024a21a13fcfa0f840002d8798082196ec71a007e3127840300d8798082199f5f1a00bc09d0f5f6
```

This is `1358` bytes and you can inspect it using <a href="https://cbor.me/?bytes=84(AC(00-83(82(58.20(9EA0D817DC67CE8046F6C2ABC27267905C74374530C4684BB3C252ED6B97CC87)-02)-82(58.20(E3195E7888A83F3D1EF218E50675BFA10D9817A4A756B8BA26305F604C0F96E5)-00)-82(58.20(285C77A9E62C0F87FEDFCC91A630251CE2B7FCB9DD8D2FD8591C0D0ABA46D4BC)-00))-01-83(A3(00-58.39(11E0302560CED2FDCBFCB2602697DF970CD0D6A38F94B32703F51C312BBC10FE312ACD69E2E12CBC2CCA05AA0E432E3DEE65D5A9498344E4AA)-01-82(1B.00000082DEEF6E00-A2(58.1C(5D16CC1A177B5D9BA9CFA9793B07E60F1FB70FEA1F8AEF064415D114)-A1(43(494147)-1B.0000016F8A787B24)-58.1C(E0302560CED2FDCBFCB2602697DF970CD0D6A38F94B32703F51C312B)-A1(58.20(000DE1406F79E3E55EEF82B9D03CF62CC3D4A6D0D03B00BF7B1B43330F829779)-01)))-02-82(01-D8.18(58.62(D8799F581C6F79E3E55EEF82B9D03CF62CC3D4A6D0D03B00BF7B1B43330F8297799F9F4040FF9F581C5D16CC1A177B5D9BA9CFA9793B07E60F1FB70FEA1F8AEF064415D11443494147FFFF1B000000C823A3F15C18641864D87A80001A73C3BE00FF))))-82(58.39(0123A9F67AF7E7E6D1AA0B495F68787649BB6F097D6648C2FA59C185E400168E1B0B38FE76F31427EE638ADBA1B7AD61AB8274FF4ECAA4109E)-82(1A.001E8480-A1(58.1C(5D16CC1A177B5D9BA9CFA9793B07E60F1FB70FEA1F8AEF064415D114)-A1(43(494147)-1A.FAD8CC91))))-82(58.1D(618CA0E08CDBC30FA0DD21833D7370D666493ECC28B136DF179F97FB5D)-1A.6079B955))-02-1A.00092E4D-03-1A.08E498D7-05-A1(58.1D(F199E5AACF401FED0EB0E2993D72D423947F42342E8F848353D03EFE61)-00)-08-1A.08E49107-0B-58.20(B159FEADC14235013A7AC8E993B410E5CDBD69C5829CD06B463603F15A39E666)-0D-81(82(58.20(9EA0D817DC67CE8046F6C2ABC27267905C74374530C4684BB3C252ED6B97CC87)-02))-0E-81(58.1C(8CA0E08CDBC30FA0DD21833D7370D666493ECC28B136DF179F97FB5D))-10-82(58.1D(618CA0E08CDBC30FA0DD21833D7370D666493ECC28B136DF179F97FB5D)-1A.60369C62)-11-1A.004C4B40-12-83(82(58.20(FA46A1D162C59CECE3308C5A9D4DB9FF2EA17F9C0146FF821C9B445588B017C9)-00)-82(58.20(F5F1BDFAD3EB4D67D2FC36F36F47FC2938CF6F001689184AB320735A28642CF2)-00)-82(58.20(0258EC397CBD4A86951126BD2C423D62F71EC844430964CD0E14DF2F951906A4)-00)))-A3(00-81(82(58.20(43BE65BFB94286317D1274FF4C1D4890DDC524D04D1182C4C714E97E19859548)-58.40(1A5D1672AED8D170F343C2D517D8475F3569DF6E1DB0741091A2FCC3AAE92A520B9496E91A005544B8D1AE938525666BA732F8A88945FB8BA859F91B2636EE07)))-06-81(59.0145(5901420100003323232323232322322253330053253330063370E900218039BAA300130083754004264A66600E66E1D2000300837540022646600200264A66601266E1D2002300A3754002297ADEF6C6013756601C60166EA8004C8CC004004DD5980218059BAA300E300B375400644A66601A0022980103D87A80001323232533300D3371E0166EB8C03800C4CDD2A4000660226E980052F5C026600A00A0046EACC038008C044008C03C004894CCC030004528099299980519B873371C6EB8C02CC03C00920024806852889980180180098078008B1929998050008A6103D87A800013374A9000198059806000A5EB80DD618059806180618041BAA300B3008375400429408C02CC03000452613656375C002AE6955CEAAB9E5573EAE815D0ABA24C011E581CE0302560CED2FDCBFCB2602697DF970CD0D6A38F94B32703F51C312B0001))-05-83(84(00-00-D8.7A(9F(D8.79(9F(00-0D-9F(9F(02-D8.7A(80)-00-FF)-FF)-FF))-FF))-82(1A.001024A2-1A.13FCFA0F))-84(00-02-D8.79(80)-82(19.6EC7-1A.007E3127))-84(03-00-D8.79(80)-82(19.9F5F-1A.00BC09D0))))-F5-F6)">cbor.me</a>

Among the inputs and reference inputs, there are 2 inputs which, when resolved, contain reference scripts:

- reference input `f5f1bdfad3eb4d67d2fc36f36f47fc2938cf6f001689184ab320735a28642cf2#0` with `2469` bytes
- reference input `fa46a1d162c59cece3308c5a9d4db9ff2ea17f9c0146ff821c9b445588b017c9#0` with `15728` bytes

And there are three redeemers:

- Spend#0 with a budget of `1057954` memory units, and `335346191` steps
- Spend#2 with a budget of `28359` memory units, and `8270119` steps
- Withdraw#0 with a budget of `40799` memory units, and `12323280` steps

The protocol parameters at the time were:

- `minFeeConstant`: `155381` lovelace
- `minFeeCoefficient`: `44` lovelace per byte
- `minFeeReferenceScripts`:
  - `base`: `15` lovelace
  - `multiplier`: `1.2`
  - `size increment`: `25600` bytes
- `prices.memory`: `0.0577` lovelace per memory unit
- `prices.steps`: `0.0000721` lovelace per step

Thus:

- The base fee is `155381 + 44 * 1358 = 215133` lovelace.
- The total reference scripts length is `2469 + 15728 = 18197` and fall under the 25,600 byte increment, so it costs `15` lovelace per byte: `15 * min(18197, 25600) = 15 * 18197 = 272955` lovelace
- And the execution costs are `ceil(1057954 * 0.0577 + 335346191 * 0.0000721 + 28359 * 0.0577 + 8270119 * 0.0000721 + 40799 * 0.0577 + 12323280 * 0.0000721) = ceil(90697.606839) = 90698` lovelace.

Thus, the total minimum fee is `578786` lovelace.

Note that historically calculating this has been pretty opaque, and so many people have resorted to slightly padding the minimum fee, and I believe this is why the on-chain minimum fee (which is declared in the transaction body) is `601677` lovelace.
