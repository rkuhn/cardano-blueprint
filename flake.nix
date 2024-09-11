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
          overlays = [
            (self: super: {
              mdbook-mermaid = super.mdbook-mermaid.overrideAttrs (prev: {
                version = "0.13.0+mermaid-1.11";
                src = pkgs.fetchFromGitHub {
                  owner = "ch1bo";
                  repo = "mdbook-mermaid";
                  rev = "860c2ff8ec97bd9e4959799906fc76ecbb2a675b";
                  sha256 = "sha256-6+QLZnkr2yse4nYxNtKE9clfxhhaXscbt8KLJnWNs2M=";
                };
              });
            })
          ];
        };
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
