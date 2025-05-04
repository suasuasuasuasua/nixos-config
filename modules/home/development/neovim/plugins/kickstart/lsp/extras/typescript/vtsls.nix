{
  lib,
  config,
  ...
}:
let
  name = "vtsls";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.vtsls = {
      enable = true;
      # NOTE: add options as I need
    };
  };
}
