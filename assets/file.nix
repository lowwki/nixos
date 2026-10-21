{ ... }:
{
   flake.nixosModules.app-file = { pkgs, ... }: {
   	environment.systemPackages = with pkgs; [ 
        nautilus 
        zathura 
        imv
        vlc
       ];
   };
}   
