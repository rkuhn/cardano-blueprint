# Built-in Types and Functions

## Built-in Types

The listing below defines the built-in types in UPLC.

```text
a ∈ Atomic type ::= integer
                  | bytestring
                  | string
                  | bool
                  | unit
                  | data
                  | 𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝙶𝟷_𝚎𝚕𝚎𝚖𝚎𝚗𝚝
                  | 𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝙶𝟸_𝚎𝚕𝚎𝚖𝚎𝚗𝚝
                  | 𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝚖𝚕𝚛𝚎𝚜𝚞𝚕𝚝

T ∈ Built-in type ::= a
                    | list(T)
                    | pair(T, T)
```

The following table shows the values and concrete syntaxes of the types and type operators:

|Type 𝑇|Value       |Concrete Syntax 𝐂(𝑇)  |
|:--|:-----------------|:-----------------|
|integer   | `ℤ` | `-?[0-9]+` |
|bytestring| the set of sequences of bytes or 8-bit characters | `#([0-9A-Fa-f][0-9A-Fa-f])*` |
|string    | the set of sequences of Unicode characters | see below |
|bool      | `{true, false}` | `True \| False` |
|unit      | `{()}` | `()` |
|data      | see below | see below |
|𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝙶𝟷_𝚎𝚕𝚎𝚖𝚎𝚗𝚝| `𝐺₁` | `0x[0-9A-Fa-f]{96}` (see below) |
|𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝙶𝟸_𝚎𝚕𝚎𝚖𝚎𝚗𝚝| `𝐺₂` | `0x[0-9A-Fa-f]{192}` (see below) |
|𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝚖𝚕𝚛𝚎𝚜𝚞𝚕𝚝| `𝐻` | see below |

For the definitions of `𝐺₁`, `𝐺₂` and `𝐻`, refer to the [Plutus Core Spec](https://plutus.cardano.intersectmbo.org/resources/plutus-core-spec.pdf).

In the following, we use `𝑐(𝑇) ∈ 𝐂(𝑇)` to denote a valid representation of a constant of type 𝑇.

### Concrete Syntax for Strings

Strings are represented as sequences of Unicode characters enclosed in
double quotes, and may include standard escape sequences.
Surrogate characters in the range `U+D800` - `U+DFFF` are replaced with the Unicode replacement character `U+FFFD`.

### Concrete Syntax for Lists and Pairs

A list of type `list(𝑡)` is written as a syntactic list `[𝑐₁, … ,𝑐ₙ]`, where each `𝑐ᵢ ∈ 𝐂(𝑡)`.

A pair of type `pair(𝑡₁, 𝑡₂)` is written as a syntactic pair `(𝑐₁, 𝑐₂)` where `𝑐₁ ∈ 𝐂(𝑡₁)` and `𝑐₂ ∈ 𝐂(𝑡₂)`.

Some valid constant expressions are:
- `(con (list integer) [11, 22, 33])`
- `(con (pair bool string) (True, "Plutus"))`
- `(con (list (pair bool (list bytestring))) [(True, []), (False, [#,#1F]), (True, [#123456, #AB, #ef2804])])`

### The `data` Type

We provide a built-in type, `data`, which permits the encoding of simple data structures
for use as arguments to Plutus Core scripts.
The Haskell definition of `data` can be found in [PlutusCore.Data](https://plutus.cardano.intersectmbo.org/haddock/latest/plutus-core/PlutusCore-Data.html#t:Data).

### Concrete Syntax for `data`

The concrete syntax for 𝚍𝚊𝚝𝚊 is given by

```text
𝑐(𝚍𝚊𝚝𝚊) ∶∶= (Constr 𝑐(𝚒𝚗𝚝𝚎𝚐𝚎𝚛) 𝑐(𝚕𝚒𝚜𝚝(𝚍𝚊𝚝𝚊)))
          | (Map 𝑐(𝚕𝚒𝚜𝚝(𝚙𝚊𝚒𝚛(𝚍𝚊𝚝𝚊,𝚍𝚊𝚝𝚊))))
          | (List 𝑐(𝚕𝚒𝚜𝚝(𝚍𝚊𝚝𝚊)))
          | (I 𝑐(𝚒𝚗𝚝𝚎𝚐𝚎𝚛))
          | (B 𝑐(𝚋𝚢𝚝𝚎𝚜𝚝𝚛𝚒𝚗𝚐)).
```

Some valid data constants are:
- `(con data (Constr 1 [(I 2), (B #), (Map [])]))`
- `(con data (Map [((I 0), (B #00)), ((I 1), (B #0F))]))`
- `(con data (List [(I 0), (I 1), (B #7FFF), (List []])))`
- `(con data (I -22))`
- `(con data (B #001A))`

### Concrete syntax for BLS12-381 Types

The concrete syntaxes for `𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝙶𝟷_𝚎𝚕𝚎𝚖𝚎𝚗𝚝` and `𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝙶𝟸_𝚎𝚕𝚎𝚖𝚎𝚗𝚝` are provided only for use in textual Plutus Core programs, for example for experimentation and testing.
We do not support constants of any of the BLS12-381 types in serialised programs.

If you need to put `𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝙶𝟷_𝚎𝚕𝚎𝚖𝚎𝚗𝚝` and `𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝙶𝟸_𝚎𝚕𝚎𝚖𝚎𝚗𝚝` in your script, you can instead use the appropriate uncompression function on a bytestring constant.

No concrete syntax is provided for values of type `𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝚖𝚕𝚛𝚎𝚜𝚞𝚕𝚝`.
It is not possible to parse such values, and they will appear as `(con bls12_381_mlresult <opaque>)` if output by a program.

## Built-in Functions

Plutus includes a set of built-in functions.
Like in Haskell, these can be polymorphic, accepting both type and term arguments.
However, Plutus distinguishes between two kinds of type arguments:
- A built-in-polymorphic type argument (denoted as `𝑎#`, `𝑏#` etc. in the spec) is limited to built-in types.
- A fully-polymorphic type argument (denoted as `∗` in the spec) represents arbitrary terms.

`∗` can not be used as an argument to a type operator.
For instance, `list(∗)` is not allowed, whereas `list(𝑎#)` and `pair(𝑎#, integer)` are valid.

A term argument of type `∗` can be any UPLC term.
Multiple arguments of type `∗` are independent and need not be related.
All other term arguments must be UPLC constants of the appropriate types.
For example, an argument of type `pair(𝑎#, 𝑎#)` must be a pair constant, where both components are constants of the same built-in type.

A built-in function returns an application consisting of a head and zero or more arguments.
Most built-in functions returns a single value, which corresponds to an application with zero argument.
Each of the head and the arguments may be either a UPLC constant, or of type `∗`.
If it is of type `∗`, it must be one of the arguments passed to the built-in function, unmodified.

Take built-in function `ifThenElse` as an example.
It has signature `[∀∗, 𝚋𝚘𝚘𝚕, ∗, ∗] → ∗`.
Thus it takes three term arguments: a `bool` constant, followed by two arbitrary terms.
Since its return type is `∗`, the result must be either the second argument or the third argument.

As another example, built-in function `mkCons` has signature `[∀𝑎#, 𝑎#, 𝚕𝚒𝚜𝚝(𝑎#)] → 𝚕𝚒𝚜𝚝(𝑎#)`, indicating that it takes a constant of some type, and a list constant whose elements are of the same type.
The result is a list constant of the same element type.

Type arguments are not passed explicitly when calling a built-in function.
In UPLC, type instantiation is achieved via the `force` construct.

Because introducing built-in functions requires a hard fork, each built-in function is introduced in a specific major protocol version.
For example, `integerToByteString` was introduced in major protocol version 9 (following the Chang hard fork).
Moreover, not all built-in functions are available in every Plutus ledger language version (Plutus V1, V2, V3).
Scripts using an unavailable built-in function will be rejected by the Cardano node.
More details will be provided in Script Deserialization and Execution.

For the full list of UPLC built-in functions, their signatures, semantics, and supported Plutus ledger language versions and protocol versions, refer to the [Plutus Core Spec](https://plutus.cardano.intersectmbo.org/resources/plutus-core-spec.pdf), Section 4.3 (Built-in types and functions).
