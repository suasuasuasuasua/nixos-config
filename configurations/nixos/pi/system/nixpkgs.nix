{
  # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs = {
    overlays = [
      (_: prev: {
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
        # https://github.com/NixOS/nixpkgs/issues/500713
        glances = prev.glances.overrideAttrs (_: {
          doCheck = false;
        });
      })
    ];
  };
}
