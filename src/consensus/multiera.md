# Multi-era considerations

With the blockchain network evolving, the block format and ledger
rules are bound to change. In Cardano, every significant change starts
a new "era". There are several ways to deal with multiple eras in the
node software, associated here with some of [the DnD
alignments](<https://en.wikipedia.org/wiki/Alignment_(role-playing_games)#Dungeons_&_Dragons>):

- Chaotic Evil: the node software only ever implements one era. When
  the protocol needs to be updated, all participants must update the
  software or risk being ejected from the network. Most importantly, the
  decision to transition to the new era needs to happen off-chain.

  - Pros:

    - the simplest possible node software.

  - Cons:

    - on-chain governance of the hard-fork is impossible, as the
      software has no way of knowing where the era boundary is and
      does not even have such a concept.
    - Additionally, special care is needed to process history blocks:
      chain replay is likely to be handled by special code, separate
      from the active era's logic.

- Chaotic Good: the node software supports the current era and the
  next era. Once the next era is adopted, a grace period is allowed
  for the participants to upgrade. The decision to upgrade may happen
  on chain.

  - Pros:
    - allows for on-chain governance of the hard fork.
  - Cons:
    - supporting two eras is more difficult than one: higher chances
      of bugs that will cause the network to fork in an unintended
      way.
    - Like in the previous case, special care is needed to process
      historic blocks.

- True Neutral: software is structured in such a way that is supports
  all eras.

  - Pros:
    - enables massive code reuse and forces the code to be structured
      in the way that allows for abstract manipulation of blocks of
      different eras.
    - The on-chain governance of hard-forks is reflected in the code,
      and ideally in the types as well, making it more likely that
      unintended scenarios are either impossible or easily discover
      able through type checking and testing.
  - Cons:
    - abstraction is a double-edged sword and may be difficult to
      encode in some programming languages.
    - Engineers require extended onboarding to be productive.

We argue that Cardano has been the True Neutral so far, which allowed
to maintain the stability of the network while allowing it to change
and evolve.

Having multiple eras comes with some subtleties on era boundaries that
implementors need to take into account:

## Time

## Forecast range
