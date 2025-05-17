{
  description = "A very basic flake";

  outputs = {self}: {
    templates.poetry2nix = {
      path = ./poetry2nix;
      description = "Basic poetry2nix templates";
      welcomeText = ''
        A basic poetry2nix flake with a dev shell enabled.

        Optionnaly nixld can be used for dynamically link packages
      '';
    };

    templates.pyproject2nix = {
      path = ./pyproject2nix;
      description = "pyproject.nix template with poetry";
      welcomeText = ''
        This flake use pyproject.toml to create a nix python env from
        the nixpkgs package set. The lock file is ignored. Suitable
        for dev env
      '';
    };

    templates.default = self.templates.poetry2nix;
  };
}
