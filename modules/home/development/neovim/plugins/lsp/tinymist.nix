{
  lib,
  config,
  ...
}:
let
  name = "tinymist";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.tinymist = {
      enable = true;
      # NOTE: add options as I need
      settings = {
        formatterMode = "typstyle";
        # generally i like 80, but links, math blocks, etc. can be large
        formatterPrintWidth = 120;
      };
    };
  };
}
