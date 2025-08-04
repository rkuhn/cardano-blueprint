<div align="center">
  <img src="logo/logo.svg"></img>
  <h1>Cardano Blueprint</h1>
</div>

Welcome to the Cardano Blueprint, a project that aims to serve as a knowledge
foundation about how the Cardano protocol works. Blueprints are implementation
independent assets, diagrams, specifications, test data, etc. that will enable a
wide developer audience to understand the protocol and build Cardano components.

<div align="center">
  👉 <a href="https://cardano-scaling.github.io/cardano-blueprint"><big>Introduction</big></a> 👈
</div>

## Building

The blueprints are written using markdown and can be viewed [directly in
Github](./src/introduction/README.md) or built into [the HTML
site](https://cardano-scaling.github.io/cardano-blueprint) using [mdbook].

### With cargo

You can install [mdbook] and the plugins we use with `cargo`:

```shell
cargo install mdbook mdbook-katex mdbook-mermaid mdbook-alerts mdbook-toc
```

Then, build with:

```shell
mdbook build
```

<details>
<summary>Binary install</summary>

There's also an option to install directly from binaries with `cargo binstall`:

```shell
cargo install cargo-binstall         # If you don't already have it
cargo binstall mdbook mdbook-katex mdbook-mermaid mdbook-alerts mdbook-toc
```

</details>

### With nix

You can also use [nix]:

```shell
nix build -o out
```

## Editing

With [mdbook] installed or inside a `nix develop` shell, you can live preview
the result with:

```shell
mdbook serve --open
```

See the [mdbook manual][mdbook] or [github flavored markdown][gfm] for
more information on what is available for editing.

### Formatting & spell checking

We use `treefmt` that runs a few formatting and spell checking tools. This is
also enforced through CI. See `formattingPkgs` in [`flake.nix`](./flake.nix) for
a list of packages needed, then:

```shell
treefmt
```

## License

Cardano Blueprint created by [the Cardano Blueprint
contributors](https://github.com/cardano-scaling/cardano-blueprint/graphs/contributors)
is licensed under the [Apache 2.0 License](./LICENSE).

## Logo

The [logo and wordmark](./logo/README.md) for the Cardano Blueprint was created
by Roberto Nicolo, Sebastian Nagel and Input Output Global Ltd. Obviously, the
design is derived from the official Cardano logo and we hereby accept and intend
to follow the [official trademark
policy](https://www.cardanofoundation.org/policy/trademark-policy). Cardano
Blueprint is NOT registered as a trademark, nor shall it represent a commercial
product, but any artifacts produced are covered under an open source
[license](./LICENSE).

______________________________________________________________________

<p align="center">
Thanks for visiting and hopefully the cardano blueprint is useful to you 💙!
</p>

[gfm]: https://github.github.com/gfm/
[mdbook]: https://rust-lang.github.io/mdBook/index.html
[nix]: https://nixos.org/download.html
