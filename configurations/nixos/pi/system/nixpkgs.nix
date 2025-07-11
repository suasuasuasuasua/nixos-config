{
  # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs = {
    # https://blog.thalheim.io/2022/11/27/cross-compiling-and-deploying-nixos/
    # This is the architecture we build from (pkgs.system from above)
    buildPlatform = "x86_64-linux";
    # pkgsCross.<yourtarget>.system
    hostPlatform = "aarch64-linux";
    overlays = [
      (_: prev: {
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
      })
    ];
  };
}
