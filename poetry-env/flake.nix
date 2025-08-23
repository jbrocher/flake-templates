{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python313;
        pythonPackages = pkgs.python313Packages;
        poetry = pkgs.poetry.override { python3 = python; };
      in
      {
        devShell = pkgs.mkShell rec {
          buildInputs = [
            python
            poetry
          ];
          shellHook = ''
            SOURCE_DATE_EPOCH=$(date +%s)
            echo "Activating poetry env..."
            eval "$(poetry env activate)"

            venvDir=$(poetry env info -p)

            # Under some circumstances it might be necessary to add your virtual
            # environment to PYTHONPATH, which you can do here too;
            PYTHONPATH=$PWD/$venvDir/${pythonPackages.python.sitePackages}/:$PYTHONPATH
          '';
        };
      }
    );
}
