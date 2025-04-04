{
  lib,
  config,
  ...
}:
let
  name = "auto-session";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.auto-session = {
        enable = true;

        settings = {
          enabled = true;
          auto_create = true;
          # TODO: not saving when false?
          # could change in the future--but leave it up to mini.starter
          auto_restore = true;
          auto_save = true;
        };
      };
    };
  };
}
