# Package aggregation: robot, widoco, ontology-toolkit, load-vocabularies
{ config, pkgs, ... }: {
  perSystem = { pkgs, system, ... }: {
    packages = {
      robot = pkgs.callPackage ../packages/robot.nix { };
      widoco = pkgs.callPackage ../packages/widoco.nix { };
      ontology-toolkit = pkgs.callPackage ../packages/ontology-toolkit.nix { };
      load-vocabularies = pkgs.callPackage ../packages/load-vocabularies.nix { };
    };
  };
}
