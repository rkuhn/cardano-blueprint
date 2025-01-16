# Notes on building Cardano Blueprints

The following are tips for installing mdbook to build the full blueprint
project.  You don't need to do this if you just want to read them, or submit
changes to existing pages if you're happy editing markdown, but it is a good
way to preview them.

## Installing mdbook in cargo

If you're a Rust developer and use cargo, you can install mdbook and the
plugins we use with `cargo`:

```shell
cargo install mdbook mdbook-katex mdbook-mermaid mdbook-alerts
```

Assuming you have your PATH set up to point to your cargo `bin/` directory,
you should then be able to run `mdbook` with live updates:

```shell
mdbook serve -o
```

### Binary installs

There's also an option to install directly from binaries with `cargo binstall`:

```shell
cargo install cargo-binstall         # If you don't already have it
cargo binstall mdbook mdbook-katex mdbook-mermaid mdbook-alerts
```

