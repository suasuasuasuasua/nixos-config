{
  devices = {
    "lab" = {
      id = "BGFPQUX-W2TYGWY-SK24RJT-LXBPBLG-SGUEN24-LQ5SIYN-ZVTHVZQ-6N3B4QY";
    };
    "mbp3" = {
      id = "V4NCONK-S2JLQLH-AQULXDL-Y4QQWBB-FO67NEP-G2Q2SSG-BQF4ZPW-5VHRGAY";
    };
    "penguin" = {
      id = "I5INTQG-B54MRIS-XCFCVO3-JMJRYHX-IP2U4HO-KDHB34G-ECE6SOD-7V3IQAS";
    };
  };
  folders = {
    "default" = {
      path = "/zshare/personal/notes/";
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
