{
  config,
  lib,
  ...
}:
let
  cfg = config.home.development.neovim;
in
{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      opts = {
        cc = "80,81";
        textwidth = 80;
        conceallevel = 2;

        backup = false;
        writebackup = false;
        swapfile = false;
      };
      keymaps = [
        {
          mode = "i";
          key = "jk";
          action = "<Esc>";
        }
      ];
    };
  };
}
