# Library helpers for ontology projects.
{ config, ... }: {
  flake.lib = {
    # Helper to build ontology project derivations from a schema path.
    # Usage: mkOntologyProject { schema = ./src/schema.yaml; outputDir = "generated"; }
    # Returns an attrset with optional derivations or scripts (extensible).
    mkOntologyProject = { schema, outputDir ? "generated", pkgs ? null }: let
      pkg = if pkgs != null then pkgs else throw "mkOntologyProject requires pkgs";
    in {
      inherit schema outputDir;
      # Placeholder for project-specific generate/validate derivations when needed
      # (e.g. runOntologyGenerate = pkg.runCommand "generate" {} "onto-generate ${schema} -o ${outputDir}";)
    };
  };
}
