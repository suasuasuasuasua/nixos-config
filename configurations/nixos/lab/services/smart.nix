# Monitor the drives in the computer using smartmontools (S.M.A.R.T.)
{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.smartmontools
  ];

  services.smartd = {
    enable = true;

    autodetect = false;
    devices = [
      # sata ssd 1
      {
        device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S4XANE0M746762J";
        options = "-d sat";
      }
      # sata hdd 1
      {
        device = "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62YABN";
        options = "-d sat";
      }
      # sata hdd 2
      {
        device = "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62YARM";
        options = "-d sat";
      }
      # sata hdd 3
      {
        device = "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62YBMB";
        options = "-d sat";
      }

      # TODO: i guess these nvme's can't do the smart test? i am reading that
      # it's fine anyway and ssds don't need this?
      # # nvme 1
      # {
      #   device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_2TB_245268800136";
      #   options = "-d nvme";
      # }
      # # nvme 2
      # {
      #   device = "/dev/disk/by-id/nvme-wd_black_sn770_2tb_245268801871";
      #   options = "-d nvme";
      # }
    ];
  };
}
