{
  inputs,
  self,
  ...
}: {
  flake.wrappersModules.niri = {
    config,
    lib, 
    ...
  }: {
  options.terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
    };
  config = {
    settings = let
        quickshellExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.quickshell;
        launcher = fn: [ quickshellExe "ipc" "call" "launcher" fn ];
in {
    prefer-no-csd = _: { };
    hotkey-overlay = {
	  skip-at-startup = _: { };
	 };

    input = {
      focus-follows-mouse = _: { };
      keyboard = {
        xkb = {
          layout = "us";
        };
     };

    touchpad = {
      natural-scroll = _: { };
      tap = _: { };
      dwt = _:{ };
     };

    mouse = {
      accel-profile = "flat";
     };
    };

    binds = {
          "Mod+Space".spawn = launcher "apps";        # apps, plus the system actions when you type
          "Mod+Alt+Space".spawn   = launcher "files";       # starts with "f "
          "Mod+Shift+V".spawn     = launcher "clipboard";   # starts with "c "
          "Mod+Period".spawn      = launcher "emoji";       # starts with "e "
        

          "Mod+Return".spawn = config.terminal;

          "Mod+Q".close-window = _: { };
          "Mod+F".maximize-column = _: { };
          "Mod+G".fullscreen-window = _: { };
          "Mod+Shift+F".toggle-window-floating = _: { };
          "Mod+C".center-column = _: { };

          "Mod+H".focus-column-left = _: { };
          "Mod+L".focus-column-right = _: { };
          "Mod+K".focus-window-up = _: { };
          "Mod+J".focus-window-down = _: { };

          "Mod+Left".focus-column-left = _: { };
          "Mod+Right".focus-column-right = _: { };
          "Mod+Up".focus-window-up = _: { };
          "Mod+Down".focus-window-down = _: { };

          "Mod+Shift+H".move-column-left = _: { };
          "Mod+Shift+L".move-column-right = _: { };
          "Mod+Shift+K".move-window-up = _: { };
          "Mod+Shift+J".move-window-down = _: { };

          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;
          "Mod+0".focus-workspace = 10;

          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;
          "Mod+Shift+6".move-column-to-workspace = 6;
          "Mod+Shift+7".move-column-to-workspace = 7;
          "Mod+Shift+8".move-column-to-workspace = 8;
          "Mod+Shift+9".move-column-to-workspace = 9;
          "Mod+Shift+0".move-column-to-workspace = 10;

	      "Mod+Tab".toggle-overview = _: { };

          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

          "Mod+Ctrl+H".set-column-width = "-5%";
          "Mod+Ctrl+L".set-column-width = "+5%";
          "Mod+Ctrl+J".set-window-height = "-5%";
          "Mod+Ctrl+K".set-window-height = "+5%";

          "Mod+WheelScrollDown".focus-column-left = _: { };
          "Mod+WheelScrollUp".focus-column-right = _: { };
          "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: { };
          "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: { };

            #[ "${pkgs.lib.getExe' pkgs.wl-clipboard "wl-paste"}" ];
	      "Print".screenshot = _: { };                  # interactive region select           
	      "Ctrl+Print".screenshot-screen = _: { };      # whole focused monitor
	      "Alt+Print".screenshot-window = _: { };       # focused window
       };

    layout = {
       gaps = 4;

       focus-ring = {
         width = 1;
         active-color = "#${self.themeNoHash.base0C}";
        };
    };
    window-rules = [
       { opacity = 0.85; }
    {
       matches = [ { is-focused = true; } ];
       opacity = 1.0;
    }
    {
       matches = [
        { app-id = "^org.pulseaudio.pavucontrol$"; }
        { app-id = "blueman-manager"; }
      ];
      open-floating = true;
      default-column-width = { fixed = 600; };
      default-window-height = { fixed = 400; };
    }
   ];
    cursor = {
  	  xcursor-theme = "Bibata-Modern-Classic";
      xcursor-size = 20;
    };

    xwayland-satellite.path = lib.getExe config.pkgs.xwayland-satellite;

        spawn-at-startup = [
          quickshellExe
          (lib.getExe (
            config.pkgs.writeShellScriptBin "wallpaper"
            "${lib.getExe config.pkgs.swaybg} -i ${self.wallpaper} -m fill"
          ))
        ];
      };
    };
  };

  perSystem = {pkgs, ...}: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.niri];
    };
  };
}
