{
  config,
  lib,
  ...
}:
let
  cfg = config.home.development.neovim;

  inherit (lib.types) bool enum;
in
{
  options.home.development.neovim = {
    colorscheme = {
      enable = lib.mkOption {
        type = bool;
        default = true;
        description = "Enable colorschemes for Neovim";
      };
      name = lib.mkOption {
        type = enum [
          "catppuccin"
          "everforest"
          "tokyonight"
          "vscode"
        ];
        default = "vscode";
      };
    };
  };

  config = lib.mkIf cfg.colorscheme.enable {
    # You can easily change to a different colorscheme.
    # Add your colorscheme here and enable it.
    # Don't forget to disable the colorschemes you arent using
    #
    # If you want to see what colorschemes are already installed, you can use
    # `:Telescope colorscheme`.
    programs.nixvim.colorschemes = lib.mkIf cfg.colorscheme.enable {
      # https://nix-community.github.io/nixvim/colorschemes/catppuccin/index.html
      catppuccin = lib.mkIf (cfg.colorscheme.name == "catppuccin") {
        enable = true;
        lazyLoad.enable = true;
        settings = {
          default_integrations = true;
          # one of “latte”, “mocha”, “frappe”, “macchiato”, “auto”
          flavour = "mocha";
        };
      };
      # https://nix-community.github.io/nixvim/colorschemes/everforest/index.html
      # * current
      everforest = lib.mkIf (cfg.colorscheme.name == "everforest") {
        enable = true;
        settings = {
          enable_italic = 1;
          # one of “hard”, “medium”, “soft”
          background = "hard";
        };
      };
      # https://nix-community.github.io/nixvim/colorschemes/tokyonight/index.html
      tokyonight = lib.mkIf (cfg.colorscheme.name == "tokyonight") {
        enable = true;
        lazyLoad.enable = true;
        settings = {
          # Like many other themes, this one has different styles, and you could
          # load any other, such as 'storm', 'moon', or 'day'.
          style = "night";
        };
      };
      # https://nix-community.github.io/nixvim/colorschemes/vscode/index.html
      vscode = lib.mkIf (cfg.colorscheme.name == "vscode") {
        enable = true;
        lazyLoad.enable = true;
        settings = {
          italic_comments = true;
          underline_links = true;
        };
      };
    };
  };
}
