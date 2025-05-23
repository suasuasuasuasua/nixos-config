{
  config,
  lib,
  ...
}:
let
  cfg = config.home.development.neovim;
in
{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # Performance tweaks
      # https://nix-community.github.io/nixvim/performance/byteCompileLua.html
      performance = {
        byteCompileLua = {
          enable = true;
          configs = true;
          initLua = true;
          nvimRuntime = true;
          plugins = true;
        };
      };
    };
  };
}
