{
  lib,
  config,
  ...
}:
let
  name = "neogit";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/NeogitOrg/neogit
      plugins.neogit = {
        enable = true;
        # not yet enabled lazy loading provider
        lazyLoad = {
          enable = false;
          settings = {
            cmd = "Neogit";
          };
        };
      };
    };
  };
}
