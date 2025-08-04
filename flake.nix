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
      in
      rec {
        inherit inputs;
        legacyPackages = pkgs;
        packages.mdbook =
          (
            pkgs.stdenv.mkDerivation {
              name = "cardano-blueprint-book";
              src = ./.;
              buildInputs = with pkgs; [
                mdbook
                mdbook-mermaid
                mdbook-katex
                mdbook-alerts
                mdbook-toc
                # formatting
                treefmt
                mdformat
                python3Packages.mdformat-footnote
                python3Packages.mdformat-gfm
                typos
              ];
              phases = [ "unpackPhase" "buildPhase" ];
              buildPhase = ''
                mdbook build -d $out
              '';
            }
          );
        defaultPackage = packages.mdbook;
      }
    );
}
