{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.git = {
    pkgs,
    ...
  }: {
    programs.git = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.git;
    };
  };
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
    };
  };
}
