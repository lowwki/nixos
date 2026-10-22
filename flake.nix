{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    wrappers.url = "github:Lassulus/wrappers";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    preservation.url = "github:nix-community/preservation";

    quickshell-config = {                                                 # linked to my repo
    	url = "git+https://codeberg.org/lowwki/quickshell";     
	    flake = false;
    };
     nautilus-my-computer = {
         url = "github:yannmasoch/nautilus-my-computer?dir=packaging/nix";
         inputs.nixpkgs.follows = "nixpkgs";
     };

    # zen-browser = {
    #     url = "github:0xc000022070/zen-browser-flake";
    #     inputs.nixpkgs.follows = "nixpkgs";
    # };

    # otter-launcher = {
    #     url = "github:kuokuo123/otter-launcher";
    #     inputs.nixpkgs.follows = "nixpkgs";
    # };
    #
    # hjem = {
    #   url = "github:feel-co/hjem";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # Import all .nix files from current directory except flake.nix recursively
  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    inherit (lib.fileset) toList fileFilter;

    isNixModule = file:
      file.hasExt "nix"
      && file.name != "flake.nix"
      && !lib.hasPrefix "_" file.name;

    importTree = path:
      toList (fileFilter isNixModule path);

    mkFlake = inputs.flake-parts.lib.mkFlake {inherit inputs;};
  in
    mkFlake {imports = importTree ./.;};
}
