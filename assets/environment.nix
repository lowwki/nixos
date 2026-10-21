{
  lib,
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    # My whole desktop in one package, includes kityy terminal
    packages.desktop = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.niri];
      terminal = lib.getExe self'.packages.terminal;
      env = {
        EDITOR = lib.getExe self'.packages.neovim;
      };
    };

    packages.terminal =
      (inputs.wrappers.wrapperModules.kitty.apply {
        inherit pkgs;
        imports = [self.wrappersModules.kitty];
        shell = lib.getExe self'.packages.environment;
      }).wrapper;

    packages.environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.fish;
      runtimeInputs = [
	pkgs.nil
	pkgs.nixd
	pkgs.statix
	pkgs.alejandra
	pkgs.manix
	pkgs.nix-inspect
	self'.packages.nh
        # other
        pkgs.file
        pkgs.unzip
        pkgs.zip
        pkgs.p7zip
        pkgs.wget
        pkgs.killall
        pkgs.fzf
        pkgs.btop
        pkgs.eza
        pkgs.fd
        pkgs.zoxide
        pkgs.ripgrep
        pkgs.fastfetch
        pkgs.tree-sitter
        pkgs.ffmpeg-full
        pkgs.lazygit
	
        # wrapped
        self'.packages.neovimDynamic
	self'.packages.qalc
	self'.packages.git
	self'.packages.jujutsu
	self'.packages.jjui
#	self'.packages.nix-check-bin	
      ];
      env = {
        EDITOR = lib.getExe self'.packages.neovimDynamic;
      };
    };

  };

}
