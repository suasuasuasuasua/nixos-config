{
  devices = {
    "legion" = {
      id = "EO6JDFA-ABEFHSV-W7BLOY2-L3QQLDA-QRD3RTW-FHYFDFT-ZX7X7IP-NEOC5QF";
    };
    "mbp3" = {
      id = "V4NCONK-S2JLQLH-AQULXDL-Y4QQWBB-FO67NEP-G2Q2SSG-BQF4ZPW-5VHRGAY";
    };
    "penguin" = {
      id = "LCNGAV7-OWFIGZF-LUKL2QJ-Q33UJIH-LCMJNBA-N4GCUZ6-ORCU6U5-OXJCQAY";
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
