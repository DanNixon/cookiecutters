{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = (import nixpkgs) {
          inherit system;
        };

{%- if cookiecutter.container_tooling %}

        rustPlatform = pkgs.makeRustPlatform {
          cargo = pkgs.cargo;
          rustc = pkgs.rustc;
        };
{%- endif %}

        nativeBuildInputs = with pkgs; [];
        buildInputs = with pkgs; [];

        lintingRustFlags = "-D unused-crate-dependencies";
      in rec {
        devShell = pkgs.mkShell {
          nativeBuildInputs = nativeBuildInputs;
          buildInputs = buildInputs;

          packages = with pkgs; [
            # Rust toolchain
            cargo
            rustc

            # Code analysis tools
            clippy
            rust-analyzer

            # Code formatting tools
            treefmt
            alejandra
            mdl
            rustfmt

            # Rust dependency linting
            cargo-deny

{%- if cookiecutter.container_tooling %}

            # Container image management tool
            skopeo
{%- endif %}
          ];

          RUSTFLAGS = lintingRustFlags;
        };
      }
    );
}
