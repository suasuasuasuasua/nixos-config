{
  # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs = {
    overlays = [
      (_: prev: {
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
        # https://github.com/NixOS/nixpkgs/issues/500713
        # pytestCheckHook runs in installCheckPhase, not checkPhase
        glances = prev.glances.overrideAttrs (_: {
          doCheck = false;
          doInstallCheck = false;
        });
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          # paho-mqtt 2.1.0 on_disconnect callback timing tests flake in the nix
          # sandbox on aarch64; on_disconnect is never fired before assertion
          (_: pyPrev: {
            paho-mqtt = pyPrev.paho-mqtt.overrideAttrs (_: {
              dontUsePytestCheck = true;
            });
          })
        ];
      })
    ];
  };
}
