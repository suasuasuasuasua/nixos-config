{
  lib,
  config,
  ...
}:
let
  name = "surround";
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
      # https://github.com/kylechui/nvim-surround
      plugins.nvim-surround = {
        enable = true;

        # TODO: figure out lazyload event -- maybe on surround?
        # lazyLoad = {
        #   enable = true;
        # };
      };
    };
  };
}
