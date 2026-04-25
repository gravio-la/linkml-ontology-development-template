{
  description = "LinkML ontology project (uses ontology-infra)";

  inputs = {
    ontology-infra.url = "github:gravio-la/linkml-ontology-development-template";
    # For local dev: ontology-infra.url = "path:../ontology-infra";
    nixpkgs.follows = "ontology-infra/nixpkgs";
  };

  outputs = { self, ontology-infra, nixpkgs }: {
    devShells = ontology-infra.devShells;
    # Optional: override or add project-specific packages
  };
}
