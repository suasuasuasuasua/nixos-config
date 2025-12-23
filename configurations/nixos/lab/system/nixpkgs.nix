{ inputs, lib, ... }:
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
  ];
}
