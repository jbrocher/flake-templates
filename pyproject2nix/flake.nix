{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    utils,
    pyproject-nix,
    ...
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        project = pyproject-nix.lib.project.loadPyproject {
          # Read & unmarshal pyproject.toml relative to this project root.
          # projectRoot is also used to set `src` for renderers such as buildPythonPackage.
          projectRoot = ./.;
        };
        python = pkgs.python3;
        arg = project.renderers.withPackages {inherit python;};
        pythonEnv = python.withPackages arg;
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              (poetry.overrideAttrs {inherit python;})
              pythonEnv
            ];
          };
          poetry = pkgs.mkShell {
            packages = [
              (pkgs.poetry.overrideAttrs {inherit python;})
            ];
          };
        };
      }
    );
}
