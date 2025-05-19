{
  devices = {
    "mbp3" = {
      id = "V4NCONK-S2JLQLH-AQULXDL-Y4QQWBB-FO67NEP-G2Q2SSG-BQF4ZPW-5VHRGAY";
    };
    "penguin" = {
      id = "LCNGAV7-OWFIGZF-LUKL2QJ-Q33UJIH-LCMJNBA-N4GCUZ6-ORCU6U5-OXJCQAY";
    };
  };
  folders = {
    "notes" = {
      path = "/zshare/personal/notes";
      devices = [
        "mbp3"
        "penguin"
      ];
      versioning = {
        type = "simple";
        params.keep = "10";
      };
      type = "receiveonly";
    };
  };
}
