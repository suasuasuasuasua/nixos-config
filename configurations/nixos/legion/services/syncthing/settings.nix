{
  devices = {
    "lab" = {
      id = "3ZJSMFC-WCOOIUP-HKUVIVR-WREXF56-SAVRI3E-A6BFSUV-QPA5J37-DY6KAQD";
    };
  };
  folders = {
    "notes" = {
      path = "/home/justinhoang/Documents/vaults/personal";
      devices = [
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
