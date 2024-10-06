{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    lua
    luarocks
  ];
}
