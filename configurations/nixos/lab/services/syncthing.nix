{
  devices = {
    "mbp3" = {
      id = "V4NCONK-S2JLQLH-AQULXDL-Y4QQWBB-FO67NEP-G2Q2SSG-BQF4ZPW-5VHRGAY";
    };
    "penguin" = {
      id = "SAHKA3N-4QEINWG-OBBAHC2-53PY7JW-YMA2RZD-DZ5ONQC-OW42FON-FLCRIAM";
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
