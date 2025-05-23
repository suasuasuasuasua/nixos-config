{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "remote-nvim";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.remote-nvim = {
        enable = true;
        lazyLoad = {
          enable = true;

          settings = {
            cmd = [
              "RemoteCleanup"
              "RemoteConfigDel"
              "RemoteInfo"
              "RemoteLog"
              "RemoteStart"
              "RemoteStop"
            ];
          };
        };
      };

      extraPackages = with pkgs; [
        devpod
      ];
    };
  };
}
