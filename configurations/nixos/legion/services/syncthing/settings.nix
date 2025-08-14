{
  devices = {
    "lab" = {
      id = "BGFPQUX-W2TYGWY-SK24RJT-LXBPBLG-SGUEN24-LQ5SIYN-ZVTHVZQ-6N3B4QY";
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
