{
  lib,
  config,
  ...
}:
let
  name = "remote-nvim";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # NOTE: available on unstable 25.05 currently
      # https://github.com/amitds1997/remote-nvim.nvim
      plugins.remote-nvim = {
        enable = true;
      };
    };
  };
}
