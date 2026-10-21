{
    flake.nixosModules.app-librewolf = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.librewolf ];
    };
}
