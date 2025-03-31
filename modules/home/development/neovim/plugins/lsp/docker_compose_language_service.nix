{
  lib,
  config,
  ...
}:
let
  name = "docker_compose_language_service";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.docker_compose_language_service = {
      enable = true;
      # NOTE: add options as I need
    };
  };
}
