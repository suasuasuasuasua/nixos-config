{
  devices = {
    "legion" = {
      id = "EO6JDFA-ABEFHSV-W7BLOY2-L3QQLDA-QRD3RTW-FHYFDFT-ZX7X7IP-NEOC5QF";
    };
    "mbp3" = {
      id = "V4NCONK-S2JLQLH-AQULXDL-Y4QQWBB-FO67NEP-G2Q2SSG-BQF4ZPW-5VHRGAY";
    };
    "penguin" = {
      id = "RAMVSDB-OWQWKZJ-PFGUAHV-6P2YX2T-CKVVOSG-4O2CY5F-BEIBRPU-ILBMIAR";
    };
  };
  folders = {
    "personal" = {
      path = "/zshare/personal/notes/personal/";
      devices = [
        "legion"
        "mbp3"
        "penguin"
      ];
      versioning = {
        type = "simple";
        params.keep = "10";
      };
    };
    "productivity" = {
      path = "/zshare/personal/notes/productivity/";
      devices = [
        "legion"
        "mbp3"
        "penguin"
      ];
      versioning = {
        type = "simple";
        params.keep = "10";
      };
    };
  };
}
