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
      };

      extraPackages = with pkgs; [
        devpod
      ];
    };
  };
}
