{
  description = "Reproducible NixOS infrastructure for ontology engineering (LinkML, SHACL, triple stores, Graviola)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        ./flake/devShells.nix
        ./flake/packages.nix
        ./flake/lib.nix
      ];

      flake = {
        nixosModules = {
          virtuoso = ./modules/virtuoso.nix;
          oxigraph = ./modules/oxigraph.nix;
          nginx-proxy = ./modules/nginx-proxy.nix;
          graviola = ./modules/graviola.nix;
          webvowl = ./modules/webvowl.nix;
          docs-site = ./modules/docs-site.nix;
        };

        nixosConfigurations = {
          local-vm = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit self; };
            modules = [ ./configurations/local-vm.nix ];
          };
          contabo-server = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit self; };
            modules = [ ./configurations/contabo-server.nix ];
          };
        };

        templates = {
          ontology-project = {
            path = ./templates/ontology-project;
            description = "Scaffold for a new LinkML ontology project";
          };
        };
      };
    };
}
