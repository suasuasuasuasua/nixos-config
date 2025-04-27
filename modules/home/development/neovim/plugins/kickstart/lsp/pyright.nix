{
  lib,
  config,
  ...
}:
let
  name = "pyright";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} LSP for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.pyright = {
      enable = true;
      # NOTE: add options as I need
    };
  };
}
