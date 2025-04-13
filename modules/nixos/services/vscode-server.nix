{
  inputs,
  config,
  lib,
  ...
}:
let
  serviceName = "vscode-server";

  cfg = config.nixos.services.${serviceName};
in
{
  imports = [ inputs.vscode-server.nixosModules.default ];

  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable VScode server (FHS compliant)";
  };

  config = lib.mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}
