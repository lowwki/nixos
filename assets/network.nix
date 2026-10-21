{ ... }: {
  flake.nixosModules.network-service = { pkgs, ... }: {
    # ── NetworkManager ────────────────────────────────────────
    networking.wireless.iwd = {
      enable = true;
      settings = {
        General.EnableNetworkConfiguration = true;  # iwd handles DHCP itself
        Network.NameResolvingService = "systemd";   # uses your resolved setup
      };
   };

    # ── DNS (multi-server failover) ───────────────────────────
    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNS = [ "1.1.1.1" "9.9.9.9" "8.8.8.8" ];
        FallbackDNS = [ "1.0.0.1" "149.112.112.112" "8.8.4.4" ];
        Domains = [ "~." ];
        DNSOverTLS = "opportunistic";
        DNSSEC = "allow-downgrade";
        MulticastDNS = "no";   # avahi handles .local
      };
    };

    # ── VPN (WireGuard) ───────────────────────────────────────
    environment.systemPackages = [ pkgs.wireguard-tools pkgs.impala pkgs.iw ];
    networking.firewall.checkReversePath = "loose";
    networking.wg-quick.interfaces.wg0 = {
      autostart = false;
      address = [ "10.8.0.2/32" ];
      dns = [ "10.8.0.1" ];
      privateKeyFile = "/persist/secrets/wg0.key";
      peers = [{
        publicKey = "SERVER_PUBLIC_KEY=";
        endpoint = "vpn.example.com:51820";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        persistentKeepalive = 25;
      }];
    };
  };
}
