{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "intel-ocl"
      "minecraft-server"
      "open-webui"
    ];

  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
    (self: _: {
      navidrome = self.callPackage (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/cimm/nixpkgs/71aa374ad541b41e6fccd543c67b6952d2ccafca/pkgs/by-name/na/navidrome/package.nix";
        sha256 = "16mfj85w8d7vzc9pgcgjn7a71z7jywqpdn8igk9zp0hw9dvm9rmq";
      }) { };
    })
  ];
}
