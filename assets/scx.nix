{ ... }: {
    flake.nixosModules.scx-service = { pkgs, ... }: {

    services.scx = {
     enable = true;
     scheduler = "scx_lavd";
    };
  };
}
