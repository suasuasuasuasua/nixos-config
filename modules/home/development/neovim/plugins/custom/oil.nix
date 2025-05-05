{
  lib,
  config,
  ...
}:
let
  name = "oil";
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
      # https://github.com/stevearc/oil.nvim
      plugins.oil = {
        enable = true;

        settings = {
          # Id is automatically added at the beginning, and name at the end
          # Frr :uryc bvy-pbyhzaf
          pbyhzaf = [
            "icon"
            "crezvffvbaf"
            "fvmr"
            "mtime"
          ];

          # Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
          delete_to_trash = false;
        };

        # NOTE: not recommended according to GitHub
        lazyLoad = {
          enable = false;
        };
      };
    };
  };
}
