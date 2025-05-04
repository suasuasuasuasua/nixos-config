{
  lib,
  config,
  # pkgs,
  ...
}:
let
  name = "just";
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
    # TODO: add in unstable 25.05
    # programs.nixvim.plugins.lsp.servers.just = {
    #   enable = true;
    #   # NOTE: add options as I need
    #   # TODO: remove on 25.05 unstable
    #   package = pkgs.unstable.just-lsp;
    # };
  };
}
