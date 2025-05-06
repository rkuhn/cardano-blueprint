# Syntax

The following listing shows the concrete syntax of Plutus.
The corresponding Haskell definition can be found in [UntypedPlutusCore.Core.Type](https://plutus.cardano.intersectmbo.org/haddock/latest/plutus-core/UntypedPlutusCore-Core-Type.html#t:Term).

```text
𝐿, 𝑀, 𝑁 ∈ Term ::= 𝑥              variable
                  | (con T 𝑐)      constant 𝑐 with type T
                  | (builtin 𝑏)    built-in
                  | (lam 𝑥 𝑀)     lambda abstraction
                  | [𝑀 𝑁]         application
                  | (delay 𝑀)     delayed execution of a term
                  | (force 𝑀)     force execution of a term
                  | (constr 𝑘 𝑀₁ … 𝑀ₘ)  constructor with tag 𝑘 and 𝑚 arguments (𝑚 ≥ 0).
                                           Available since 1.1.0
                  | (case 𝑀 𝑁₁ … 𝑁ₘ)    case analysis with 𝑚 alternatives (𝑚 ≥ 0).
                                           Available since 1.1.0
                  | (error)        error

𝑃 ∈ Program ::= (program 𝑣 𝑀)  versioned program
```

Plutus (Untyped Plutus Core) is untyped in the sense that variables don't have type tags.
Constants, however, do carry type tags.
A constant must be of a built-in type.
Built-in types and functions are listed in [Built-in Types and Functions](./builtin.md).

## Version Numbers

The 𝑣 in a program is the _Plutus Core language version_, in the form of `x.y.z`.
This is distinct from the Plutus ledger language version.
For a detailed explanation, see [Different Notions of Version](https://plutus.cardano.intersectmbo.org/docs/essential-concepts/versions).

## Iterated Applications

An application of a term 𝑀 to a term 𝑁 is represented by `[𝑀 𝑁]`.
We may occasionally write `[𝑀 𝑁₁ … 𝑁ₖ]` or `[𝑀 𝑁]` as an abbreviation for an iterated application `[ … [[𝑀 𝑁₁] 𝑁₂] … 𝑁ₖ]`.

## Constructor Tags

Constructor tags can in principle be any natural number.
In practice, since they cannot be dynamically constructed, we can limit them to a fixed size without having to worry about overflow.
So we limit them to 64 bits, although this is currently only enforced in the binary format.
The Haskell definition uses `Word64` for the tag.

## de Bruijn Indices

Variable `𝑥` in the above listing can be either textual strings or de Bruijn indices.
De Bruijn indices are used in serialized scripts.
It therefore makes the most sense for a CEK machine implementation to use de Bruijn indices.

When using de Bruijn indices, the binder `𝑥` in `(lam 𝑥 𝑀)` is irrelevant, and any number can be used.
0 is a good choice since it is not a valid de Bruijn index.
