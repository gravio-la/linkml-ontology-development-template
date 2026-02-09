# Dev shell definitions — full implementation in Phase 2b
{ config, pkgs, ... }: {
  perSystem = { pkgs, system, ... }: {
    devShells.default = pkgs.mkShell {
      name = "ontology-infra-default";
      nativeBuildInputs = with pkgs; [ git ];
      meta.description = "Default dev shell (placeholder until Phase 2)";
    };
  };
}
