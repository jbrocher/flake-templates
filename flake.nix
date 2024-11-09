{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {self}: {
    templates.poetry2nix = {
      path = ./poetry2nix;
      description = "Basic poetry2nix templates";
      welcomeText = ''
        A basic poetry2nix flake with a dev shell enabled.

        Optionnaly nixld can be used for dynamically link packages
      '';
    };

    templates.default = self.templates.rust;
  };
}
