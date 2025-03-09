{
  flake,
  pkgs,
  lib,
  ...
}:
let
  inherit (flake) self;
  inherit (self) inputs;
in
{
  home = {
    username = "justinhoang";
    homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/justinhoang";
    stateVersion = "24.11";
  };

  nixpkgs = {
    overlays = [
      inputs.nur.overlay.default
    ];
    config = {
      allowUnfree = true;
    };
  };
}
