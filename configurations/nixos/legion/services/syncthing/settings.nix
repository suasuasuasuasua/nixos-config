{
  devices = {
    "lab" = {
      id = "CFGZJ7U-AHJQPLN-TKO5MRG-TEPVKQZ-7BQIOIA-KVJFA3G-XXI6ATQ-QKJNKAA";
    };
    "mbp3" = {
      id = "V4NCONK-S2JLQLH-AQULXDL-Y4QQWBB-FO67NEP-G2Q2SSG-BQF4ZPW-5VHRGAY";
    };
  };
  folders = {
    "personal" = {
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
    "productivity" = {
      path = "/home/justinhoang/Documents/vaults/productivity";
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
