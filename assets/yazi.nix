{
  flake.nixosModules.app-yazi = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.yazi ];
  };
}
