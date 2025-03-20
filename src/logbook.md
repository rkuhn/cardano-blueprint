Logbook about `cardano-blueprint` that contains thinking, discussions, pains, joys, events, and experiences that happen on a daily basis. It is supposed to be a kind of [Stream of consciousness](https://en.wikipedia.org/wiki/Stream_of_consciousness) that can later be searched, linked to or reviewed. It may also be used as a very informal decision log.

## 2025-03-20

By @ch1bo

- Started to make the logbook public with a few notes I had lying around.

## 2025-03-19

By @ch1bo

- Javier shared with me some interesting data from this article on [Node diversity on Ethereum]( https://ethereum.org/en/developers/docs/nodes-and-clients/client-diversity/)
- Also <https://clientdiversity.org/> contains most recent data on distribution of implementations!

## 2025-03-10

By @ch1bo

- Looking into [cuddle](https://github.com/input-output-hk/cuddle): The huddle tutorial looks engaging, but required a few markdown fixes
- The project contains an `.envrc` to get tools set up.. but seemingly uses (a new to me) `organist` tool using `nickel` language to manage dependencies.
- Compilation currently fails with:
  ```
  src/Codec/CBOR/Cuddle/CBOR/Gen.hs:116:10: error: [GHC-18872]
      • Couldn't match type: System.Random.Internal.MutableGen f0 (M g)
                       with: CapGenM g
  ```
- Main `README` lists support for suckets/plugs - what are these?
- Socket/plug seems to be CDDL extension point: https://datatracker.ietf.org/doc/html/rfc8610#section-3.9
- There is also `generics` feature, which seems even more powerful way to parameterize cddl rules
