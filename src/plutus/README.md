# Plutus

Plutus is Cardano’s on-chain smart contract platform.
Smart contracts can be written in a variety of languages, and compiled down to Untyped Plutus Core (UPLC), which is executed by validating nodes.
UPLC is a small functional language based on untyped lambda calculus.

Untyped lambda calculus is Turing-complete, and hence is in theory capable of performing any computation; however for efficiency reasons, UPLC includes an extensible collection of built-in types and functions.
UPLC is executed by a CEK machine.
A production implementation should be carefully engineered to maximize performance and support accurate tracking of execution costs.

The CEK machine tracks CPU and memory usage via a cost model.
There are two kinds of cost: each step the CEK machine takes (e.g., looking up a variable or processing a lambda abstraction) incurs a fixed charge; each call to a built- in function incurs a cost calculated by a costing function - a Haskell function that estimates resource usage based on the sizes of the arguments.
These are derived empirically by benchmarking the implementation with representative inputs, then using the R statistical system to fit models (e.g., 𝛼 + 𝛽𝑥𝑦 for integer multiplication, where 𝑥 and 𝑦 are the numbers of machine words required to store the arguments).
These functions are used for deterministic and efficient costing for script execution.

## Resources

- [Plinth User Guide](https://plutus.cardano.intersectmbo.org/docs/): This up-to-date guide not only covers Plinth (a Haskell-based surface language) and its compilation to UPLC, but also explains many core concepts.
  If you are relatively new to this space, start with this guide, and follow the "Essential concepts" and "Glossary" sections.

- [Plutus Core Specification](https://plutus.cardano.intersectmbo.org/resources/plutus-core-spec.pdf): Studying the spec ensures your own implementation adheres to the exact language rules.
  The specification is periodically updated as new primitives and features are added to the language.
  This blueprint covers the portion of the specification relevant to CEK machine implementation, presented in a more approachable and readable format.

- Haskell implementation: The plutus repository contains a highly optimized Haskell implementation of the CEK machine, used in the Haskell node.
  You can find the Haddock [here](https://plutus.cardano.intersectmbo.org/haddock/latest/plutus-core/UntypedPlutusCore-Evaluation-Machine-Cek.html).

- [CEK machine Wikipedia page](https://en.wikipedia.org/wiki/CEK_Machine).
