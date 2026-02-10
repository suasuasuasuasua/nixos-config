{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.home.cli.vim;
in
{
  options.custom.home.cli.vim = {
    enable = lib.mkEnableOption ''
      Vim text editor with custom configurations
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.vim = {
      enable = true;
      settings = {
        number = true;
      };
      extraConfig = ''
        " Easy escaping in insert mode
        inoremap jk <Esc>
      '';
    };
  };
}
