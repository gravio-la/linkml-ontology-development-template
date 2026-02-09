# Package aggregation — full implementation in Phase 3c
{ config, pkgs, ... }: {
  perSystem = { pkgs, system, ... }: {
    packages = { };
  };
}
