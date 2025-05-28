# Ledger CDDL specs

`cardano-ledger` provides CDDLs in their haskell packages, in the
`eras/<era>/impl/cddl-files/<era>.cddl`. These are self-contained for each
era. In our CDDL specs in the blueprint we will import them qualified via `cddlc`.
