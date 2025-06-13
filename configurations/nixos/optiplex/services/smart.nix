# Monitor the drives in the computer using smartmontools (S.M.A.R.T.)
{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.smartmontools
  ];

  services.smartd = {
    # TODO: re-enable when I get the SATA
    enable = false;

    # autodetect = false;
    devices = [
      # TODO: replace with the SATA drive
      # {
      #   device = "";
      #   options = "-d sat";
      # }
    ];
  };
}
