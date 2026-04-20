{
  description = "Cardano Blueprint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachSystem flake-utils.lib.defaultSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # mdbook-katex 0.9.x uses a fork of mdbook 0.4 and is incompatible with mdbook 0.5+.
        # Build 0.10.0-alpha which adds mdbook 0.5 support.
        mdbook-katex = pkgs.rustPlatform.buildRustPackage {
          pname = "mdbook-katex";
          version = "0.10.0-alpha";
          src = pkgs.fetchFromGitHub {
            owner = "lzanini";
            repo = "mdbook-katex";
            tag = "v0.10.0-alpha";
            hash = "sha256-etKoOLYxvUste3Ay+0Y5PGi1Lh6K/+0qz8ndc6XcQls=";
          };
          cargoHash = "sha256-LUHVGEvE22ITlmpuI+8qGBPTa7q8YssiLSfQnvGM4hw=";
        };

        formattingPkgs = with pkgs; [
          treefmt
          mdformat
          python3Packages.mdformat-footnote
          python3Packages.mdformat-gfm
          python3Packages.mdformat-myst # for latex math
          typos
        ];

        cddlPkgs = with pkgs; [
          bats
          cddl
          cddlc
        ];
      in
      rec {
        inherit inputs;
        legacyPackages = pkgs;
        defaultPackage = packages.mdbook;
        packages.mdbook = pkgs.stdenv.mkDerivation {
          name = "cardano-blueprint-book";
          src = ./.;
          buildInputs = with pkgs; [
            mdbook
            mdbook-mermaid
            mdbook-toc
          ] ++ [ mdbook-katex ];
          phases = [ "unpackPhase" "buildPhase" ];
          buildPhase = ''
            mdbook build -d $out
          '';
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.mdbook ];
          buildInputs = formattingPkgs ++ cddlPkgs;
        };
      }
    );
}
