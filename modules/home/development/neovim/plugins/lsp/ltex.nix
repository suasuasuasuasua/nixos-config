{
  lib,
  config,
  ...
}:
let
  name = "ltex";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.ltex = {
      enable = true;
      # NOTE: add options as I need
    };
  };
}
