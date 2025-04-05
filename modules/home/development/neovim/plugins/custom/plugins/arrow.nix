{
  lib,
  config,
  ...
}:
let
  name = "arrow";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.arrow = {
        enable = true;

        settings = {
          leader_key = ";";
        };
      };
    };
  };
}
