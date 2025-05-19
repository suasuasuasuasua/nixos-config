{
  devices = {
    "mbp3" = {
      id = "V4NCONK-S2JLQLH-AQULXDL-Y4QQWBB-FO67NEP-G2Q2SSG-BQF4ZPW-5VHRGAY";
    };
    "lab" = {
      id = "3ZJSMFC-WCOOIUP-HKUVIVR-WREXF56-SAVRI3E-A6BFSUV-QPA5J37-DY6KAQD";
    };
  };
  folders = {
    "notes" = {
      path = "~/Documents/vaults/personal";
      devices = [
        "mbp3"
        "lab"
      ];
      versioning = {
        type = "simple";
        params.keep = "5";
      };
      type = "sendreceive";
    };
  };
}
