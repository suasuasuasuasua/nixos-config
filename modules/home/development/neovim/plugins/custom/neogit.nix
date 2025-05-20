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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/NeogitOrg/neogit/
      plugins.neogit = {
        enable = true;

        lazyLoad = {
          enable = true;
          settings = {
            cmd = "Neogit";
          };
        };
      };
    };
  };
}
