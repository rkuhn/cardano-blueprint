{
  description = "Cardano Blueprint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachSystem flake-utils.lib.defaultSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      rec {
        inherit inputs;
        packages.mdbook =
          (
            pkgs.stdenv.mkDerivation {
              name = "cardano-blueprint-book";
              src = ./.;
              buildInputs = with pkgs; [
                mdbook
                mdbook-admonish
                mdbook-mermaid
                mdbook-katex
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
