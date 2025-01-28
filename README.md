# <p align="center">Cardano Blueprint :blue_book: :triangular_ruler:</p>

Welcome to the Cardano Blueprint, a project that aims to serve as a knowledge
foundation about how the Cardano protocol works. Blueprints are implementation
independent assets, diagrams, specifications, test data, etc. that will enable a
wide developer audience to understand the protocol and build Cardano components.

<div align="center">
  👉 <a href="https://cardano-scaling.github.io/cardano-blueprint"><big>Introduction</big></a> 👈
</div>

## Building

The blueprints are written using markdown and can be viewed
[direcly in Github](./src/introduction/README.md) or built into
[the HTML site](https://cardano-scaling.github.io/cardano-blueprint)
using [mdbook][mdbook]:

``` shell
mdbook build
```

There are more [tips for building](./building/) if you need help installing
[mdbook][mdbook].

You can also use [nix][nix]:

``` shell
nix build -o out
```

## Editing

With [mdbook][mdbook] installed or inside a `nix develop` shell, you
can live preview the result with:

``` shell
mdbook serve --open
```

See the [mdbook manual][mdbook] or [github flavored markdown][gfm] for
more information on what is available for editing.

[mdbook]: https://rust-lang.github.io/mdBook/index.html
[gfm]: https://github.github.com/gfm/
[nix]: https://nixos.org/download.html
