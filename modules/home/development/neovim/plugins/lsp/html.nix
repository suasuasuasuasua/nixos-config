{
  lib,
  config,
  ...
}:
let
  name = "html";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.${name} = {
      enable = true;
      # NOTE: add options as I need
    };
  };
}
