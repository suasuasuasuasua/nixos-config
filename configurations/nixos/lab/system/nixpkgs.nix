{ inputs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "intel-ocl"
      "minecraft-server"
    ];

  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
    (_: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        # albumentations 2.0.8 test_gaussian_blur_matches_pil fails with numpy
        # array truth value ambiguity; only affects lab via immich-machine-learning
        (_: pyPrev: {
          albumentations = pyPrev.albumentations.overrideAttrs (_: {
            dontUsePytestCheck = true;
          });
        })
      ];
    })
  ];
}
