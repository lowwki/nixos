{ ... }: {
  flake.nixosModules.fs = { lib, config, pkgs, ... }:
    let
      cfg = config.my.fs;
      btrfsOpts = subvol: [ "subvol=${subvol}" "noatime" ];
    in {

    options.my.fs = {
      persistDevice = lib.mkOption {
        type = lib.types.str;
        default = "/dev/disk/by-label/persist";
        description = "btrfs partition holding the root, persist and nix subvolumes.";
      };
      bootDevice = lib.mkOption {
        type = lib.types.str;
        default = "/dev/disk/by-label/BOOT";
      };
      swapDevice = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "/dev/disk/by-label/swap";  # null = no swap
      };
    };

    config = {
      # Root is a btrfs subvolume that is deleted and recreated on every boot
      fileSystems."/" = {
        device = cfg.persistDevice;
        fsType = "btrfs";
        options = btrfsOpts "root";
      };

      fileSystems."/persist" = {
        device = cfg.persistDevice;
        fsType = "btrfs";
        options = btrfsOpts "persist";
        neededForBoot = true;
      };

      fileSystems."/nix" = {
        device = cfg.persistDevice;
        fsType = "btrfs";
        options = btrfsOpts "nix";
        neededForBoot = true;
      };

      # Real FAT partition: works as the ESP on UEFI and as /boot on BIOS
      fileSystems."/boot" = {
        device = cfg.bootDevice;
        fsType = "vfat";
        options = [ "umask=0077" ];
      };

      swapDevices = lib.optional (cfg.swapDevice != null)
        { device = cfg.swapDevice; };

      # Delete-on-boot: needs the systemd initrd (enabled in preservation.nix)
      boot.initrd.supportedFilesystems = [ "btrfs" ];
      boot.initrd.systemd.extraBin.btrfs = "${pkgs.btrfs-progs}/bin/btrfs";

      boot.initrd.systemd.services.rollback-root = {
        description = "Recreate empty btrfs root subvolume";
        wantedBy = [ "initrd.target" ];
        requires = [ "initrd-root-device.target" ];
        after = [ "initrd-root-device.target" ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /btrfs_tmp
          mount -t btrfs -o subvol=/ ${cfg.persistDevice} /btrfs_tmp

          if [ -e /btrfs_tmp/root ]; then
            btrfs subvolume list -o /btrfs_tmp/root | cut -f9 -d' ' |
            while read -r sub; do
              btrfs subvolume delete "/btrfs_tmp/$sub"
            done
            btrfs subvolume delete /btrfs_tmp/root
          fi

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };

      # GRUB can read /boot copies directly; harmless with systemd-boot
      boot.loader.grub.copyKernels = lib.mkDefault true;
    };
  };
}
