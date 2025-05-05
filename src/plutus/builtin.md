# Built-in Types and Functions

## Built-in Types

The listing below defines the built-in types in UPLC.

```text
at ∈ Atomic type ::= integer
                   | bytestring
                   | string
                   | bool
                   | unit
                   | data
                   | 𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝙶𝟷_𝚎𝚕𝚎𝚖𝚎𝚗𝚝
                   | 𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝙶𝟸_𝚎𝚕𝚎𝚖𝚎𝚗𝚝
                   | 𝚋𝚕𝚜𝟷𝟸_𝟹𝟾𝟷_𝚖𝚕𝚛𝚎𝚜𝚞𝚕𝚝

T ∈ Built-in type ::= at
                    | list(T)
                    | pair(T, T)
```

The following table shows the denotations and concrete syntaxes of the types and type operators:

|Type 𝑇|Denotation       |Concrete Syntax 𝐂(𝑇)  |
|:--|:-----------------|:-----------------|
|integer   | `ℤ` | `-?[0-9]+` |
|bytestring| `𝔹*`, the set of sequences of bytes or 8-bit characters | `#([0-9A-Fa-f][0-9A-Fa-f])*` |
|string    | `𝕌*`, the set of sequences of Unicode characters | see below |
|bool      | `{true, false}` | `True \| False` |
|unit      | `{()}` | `()` |
|data      | see below | see below |

In the following, we use `𝑐(𝑇) ∈ 𝐂(𝑇)` to denote a valid representation of a constant of type 𝑇.

### Concrete Syntax for Strings

Strings are represented as sequences of Unicode characters enclosed in
double quotes, and may include standard escape sequences.
Surrogate characters in the range `U+D800` - `U+DFFF` are replaced with the Unicode replacement character `U+FFFD`.

### Concrete Syntax for Lists and Pairs

A list of type `list(𝑡)` is written as a syntactic list `[𝑐₁, … ,𝑐ₙ]`, where each `𝑐ᵢ ∈ 𝐂(𝑡)`.

A pair of type `pair(𝑡₁, 𝑡₂)` is written as a syntactic pair `(𝑐₁, 𝑐₂)` where `𝑐₁ ∈ 𝐂(𝑡₁)` and `𝑐2 ∈ 𝐂(𝑡₂)`.

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

## Built-in Functions
