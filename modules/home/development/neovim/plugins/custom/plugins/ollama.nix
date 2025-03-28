{
  lib,
  config,
  ...
}:
let
  name = "ollama";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
    model = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    url = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.ollama = {
        inherit (cfg) model url;

        enable = true;
      };
    };
  };
}
