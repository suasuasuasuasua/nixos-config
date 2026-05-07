{ inputs, ... }:
{
  imports = [
    inputs.self.sharedModules.overlays
    inputs.self.sharedModules.system-packages
  ];
}
