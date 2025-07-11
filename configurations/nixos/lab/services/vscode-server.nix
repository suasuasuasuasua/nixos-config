# https://wiki.nixos.org/wiki/Visual_Studio_Code
{ inputs, ... }:
{
  imports = [ inputs.vscode-server.nixosModules.default ];
  services.vscode-server.enable = true;
}
