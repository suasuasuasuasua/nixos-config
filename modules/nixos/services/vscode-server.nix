{
  flake,
  config,
  lib,
  ...
}:
let
  inherit (flake) inputs;
  serviceName = "vscode-server";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable VScode server (FHS compliant)";
  };

  imports = [ inputs.vscode-server.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}
