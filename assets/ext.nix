{ self, ... }:

{
  flake.nixosModules.ext-service = { pkgs, ... }: let
  modules = with self.nixosModules; [
      nixsettings
      ];

  in {

    imports = modules;
    # ── Bluetooth ───────────────────────────────────────────────────────
# ── Audio (PipeWire + WirePlumber) ──────────────────────────────────

    

  #   networking.networkmanager.enable = true;
  #   networking.networkmanager.dns = "systemd-resolved";
  #   services.resolved = {
  #     enable = true;
  #     settings.Resolve = {
  #       DNS = [ "1.1.1.1" "9.9.9.9" "8.8.8.8" ];
  #       FallbackDNS = [ "1.0.0.1" "149.112.112.112" "8.8.4.4" ];
  #       Domains = [ "~." ];              # prefer these over DHCP-provided DNS
  #       DNSOverTLS = "opportunistic";
  #       DNSSEC = "allow-downgrade";
  #       MulticastDNS = "no";             # avahi (below) already handles .local
  #     };
  # };

    # ── Power / battery ─────────────────────────────────────────────────
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;

    # ── Brightness ──────────────────────────────────────────────────────
    # udev rules let brightnessctl change the backlight without root.
    # Your user also needs the "video" group (users.users.<name>.extraGroups).
    services.udev.packages = [ pkgs.brightnessctl ];

    # ── Desktop plumbing ────────────────────────────────────────────────
    services.dbus.enable = true;
    security.polkit.enable = true;
    services.udisks2.enable = true; # mount USB drives
    services.gvfs.enable = true;    # trash, network mounts in file managers

    services.printing.enable = true;
    services.avahi = {
        enable = true;
        nssmdns = true;
    };
  };

}
