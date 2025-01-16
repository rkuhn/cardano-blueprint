# <p align="center">Cardano Blueprint :blue_book: :triangular_ruler:</p>

Welcome to the Cardano Blueprint, a project that aims to serve as a knowledge foundation about _how_ the Cardano blockchain is built. Blueprints are implementation independent assets, diagrams, specifications, test data, etc. that will enable a wide developer audience to understand and build on Cardano. 

<div align="center">
  👉 <a href="https://cardano-scaling.github.io/cardano-blueprint"><big>Introduction</big></a> 👈
</div>

## Building

The report is written using markdown and can be viewed via the Github rendering [here](./src/introduction.md) or built into a HTML using [nix][nix]:

``` shell
nix build .#book
```

To open the result navigate your browser to `result/index.html`

Alternatively, you would need to have a [mdbook][mdbook], as well as the relevant preprocessors (see `buildInputs` in [flake.nix](./flake.nix)) to produce the same output in `build/` with:

``` shell
mdbook build
```

## Editing

We do use [mdbook][mdbook] so with the tools installed or inside a `nix develop` shell, you can live preview the result with:

``` shell
mdbook serve --open
```

See the [mdbook manual][mdbook] or [github flavored markdown][gfm] for more information on what is available for editing.

[mdbook]: https://rust-lang.github.io/mdBook/index.html
[gfm]: https://github.github.com/gfm/
[nix]: https://nixos.org/download.html
