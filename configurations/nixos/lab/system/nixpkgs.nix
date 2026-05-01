{ inputs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "intel-ocl"
      "minecraft-server"
    ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
}
