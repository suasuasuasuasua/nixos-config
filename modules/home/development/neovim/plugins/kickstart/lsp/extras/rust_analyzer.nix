{
  lib,
  config,
  ...
}:
let
  name = "rust_analyzer";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.rust_analyzer = {
      enable = true;
      # NOTE: add options as I need
      installCargo = false;
      installRustc = false;
    };
  };
}
