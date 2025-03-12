# Transaction Fees

Here is a quick writeup of how transaction fees are calculated:


Inputs:
 - Serialized Transaction Bytes
 - Transaction Redeemers
 - Protocol Parameters
   - minFeeConstant
   - minFeeCoefficient
   - minFeeReferenceScripts
   - prices.memory
   - prices.steps

At a high level, the fee is composed of a minimum constant, plus a cost per transaction byte, plus a cost per reference script byte, plus an execution cost per budgeted script redeemer.

Calculate the base fee by adding the minFeeConstant to (minFeeCoefficient * serialized transaction length in bytes). These numbers are all integers, so you shouldn't end up with a fractional amount of lovelace.

Next, calculate the untagged size of each `scriptRef` on each of the input and reference input UTxOs. Specifically, each `scriptRef` field is serialized as a cbor tag, an integer plutus version, and then the raw script bytes. We're interested in the size of the raw script bytes only.

Next, calculate the reference script fee. First, sum up the length in bytes of each of script reference. The `minFeeReferenceScripts` parameter consists of a base, a multiplier, and a range. (Note that in conway, the multiplier and the range are hard coded, rather than protocol parameters, but the intention is to change this at the next hardfork.)

To calculate the fee, starting from a `baseFee` of `minFeeReferenceScripts.base` and remaining bytes of `sum(scriptRefLengths)`, until remaining bytes is zero, add `baseFee * min(remainingBytes, minFeeReferenceScripts.range)`, scale `baseFee` by `minFeeReferenceScripts.multiplier`, and decrease remainingBytes by `min(remainingBytes, minFeeReferenceScripts.range)`.

The above calculation can result in rational values (as the multiplier can be rational), and so at the *end* of this calculation you should take the ceiling.

Finally, to calculate the evaluation fee, for each redeemer, multiply the redeemer execution units budget (memory and steps) by the corresponding protocol paramters (`prices.memory` and `prices.steps`), and add them sum them together. These are fractional parameters, so you may end with a fractional amount of lovelace, and you should take the ceiling.

The final minimum fee is the base fee, plus the reference script fee, plus the evaluation fee.

Lets do a decently complex worked example, from mainnet transaction `f06e17af7b0085b44bcc13f76008202c69865795841c692875810bc92948d609`

The script bytes are:
```
84ac00838258209ea0d817dc67ce8046f6c2abc27267905c74374530c4684bb3c252ed6b97cc8702825820e3195e7888a83f3d1ef218e50675bfa10d9817a4a756b8ba26305f604c0f96e500825820285c77a9e62c0f87fedfcc91a630251ce2b7fcb9dd8d2fd8591c0d0aba46d4bc000183a300583911e0302560ced2fdcbfcb2602697df970cd0d6a38f94b32703f51c312bbc10fe312acd69e2e12cbc2cca05aa0e432e3dee65d5a9498344e4aa01821b00000082deef6e00a2581c5d16cc1a177b5d9ba9cfa9793b07e60f1fb70fea1f8aef064415d114a1434941471b0000016f8a787b24581ce0302560ced2fdcbfcb2602697df970cd0d6a38f94b32703f51c312ba15820000de1406f79e3e55eef82b9d03cf62cc3d4a6d0d03b00bf7b1b43330f82977901028201d8185862d8799f581c6f79e3e55eef82b9d03cf62cc3d4a6d0d03b00bf7b1b43330f8297799f9f4040ff9f581c5d16cc1a177b5d9ba9cfa9793b07e60f1fb70fea1f8aef064415d11443494147ffff1b000000c823a3f15c18641864d87a80001a73c3be00ff8258390123a9f67af7e7e6d1aa0b495f68787649bb6f097d6648c2fa59c185e400168e1b0b38fe76f31427ee638adba1b7ad61ab8274ff4ecaa4109e821a001e8480a1581c5d16cc1a177b5d9ba9cfa9793b07e60f1fb70fea1f8aef064415d114a1434941471afad8cc9182581d618ca0e08cdbc30fa0dd21833d7370d666493ecc28b136df179f97fb5d1a6079b955021a00092e4d031a08e498d705a1581df199e5aacf401fed0eb0e2993d72d423947f42342e8f848353d03efe6100081a08e491070b5820b159feadc14235013a7ac8e993b410e5cdbd69c5829cd06b463603f15a39e6660d818258209ea0d817dc67ce8046f6c2abc27267905c74374530c4684bb3c252ed6b97cc87020e81581c8ca0e08cdbc30fa0dd21833d7370d666493ecc28b136df179f97fb5d1082581d618ca0e08cdbc30fa0dd21833d7370d666493ecc28b136df179f97fb5d1a60369c62111a004c4b401283825820fa46a1d162c59cece3308c5a9d4db9ff2ea17f9c0146ff821c9b445588b017c900825820f5f1bdfad3eb4d67d2fc36f36f47fc2938cf6f001689184ab320735a28642cf2008258200258ec397cbd4a86951126bd2c423d62f71ec844430964cd0e14df2f951906a400a3008182582043be65bfb94286317d1274ff4c1d4890ddc524d04d1182c4c714e97e1985954858401a5d1672aed8d170f343c2d517d8475f3569df6e1db0741091a2fcc3aae92a520b9496e91a005544b8d1ae938525666ba732f8a88945fb8ba859f91b2636ee0706815901455901420100003323232323232322322253330053253330063370e900218039baa300130083754004264a66600e66e1d2000300837540022646600200264a66601266e1d2002300a3754002297adef6c6013756601c60166ea8004c8cc004004dd5980218059baa300e300b375400644a66601a0022980103d87a80001323232533300d3371e0166eb8c03800c4cdd2a4000660226e980052f5c026600a00a0046eacc038008c044008c03c004894ccc030004528099299980519b873371c6eb8c02cc03c00920024806852889980180180098078008b1929998050008a6103d87a800013374a9000198059806000a5eb80dd618059806180618041baa300b3008375400429408c02cc03000452613656375c002ae6955ceaab9e5573eae815d0aba24c011e581ce0302560ced2fdcbfcb2602697df970cd0d6a38f94b32703f51c312b00010583840000d87a9fd8799f000d9f9f02d87a8000ffffffff821a001024a21a13fcfa0f840002d8798082196ec71a007e3127840300d8798082199f5f1a00bc09d0f5f6
```

This is **1358 bytes**.
Among the inputs and reference inputs, there are 2 inputs with refScripts:

- reference input f5f1bdfad3eb4d67d2fc36f36f47fc2938cf6f001689184ab320735a28642cf2#0 with **2469 bytes**
- reference input fa46a1d162c59cece3308c5a9d4db9ff2ea17f9c0146ff821c9b445588b017c9#0 with **15728 bytes**

And there are three redeemers:

- Spend#0 with a budget of **1057954 memory units**, and **335346191 steps**
- Spend#2 with a budget of **28359 memory units**, and **8270119 steps**
- Withdraw#0 with a budget of **40799 memory units**, and **12323280 steps**

The protocol parameters at the time were:

- minFeeConstant: 155381 lovelace
- minFeeCoefficient: 44 lovelace per byte
- minFeeReferenceScripts:
  - base: 15 lovelace
  - multiplier: 1.2
  - size increment: 25,600 bytes
- prices.memory: 0.0577 lovelace per memory unit
- prices.steps: 0.0000721 lovelace per step

Thus:

The base fee is `155381 + 44*1358 = 215133 lovelace`.
The total reference scripts fall under the 25,600 byte increment, and so it costs 15 lovelace per byte. Thus, the reference script fee is `(2469 + 15728) * 15 = 272955 lovelace`
And the execution costs are `ceil(1057954 * 0.0577 + 335346191 * 0.0000721 + 28359 * 0.0577 + 8270119 * 0.0000721 + 40799 * 0.0577 + 12323280 * 0.0000721) = ceil(90697.606839) = 90698 lovelace`.

Thus, the total minimum fee is `578786` lovelace.

Note that historically calculating this has been pretty opaque, and so many people have resorted to slightly padding the minimum fee, and I believe this is why the on-chain minimum fee (which is declared in the transaction body) is 0.602 Lovelace.
