{
  lib,
  config,
  ...
}:
let
  name = "markdown-preview";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/MeanderingProgrammer/render-markdown.nvim
      plugins.render-markdown = {
        enable = true;
      };

      plugins.lz-n = {
        # https://nix-community.github.io/nixvim/plugins/lz-n/plugins.html
        plugins = [
          {
            __unkeyed-1 = "render-markdown.nvim"; # the plugin's name (:h packadd)
            after =
              # lua
              ''
                function()
                  require('render-markdown').setup()
                end
              '';
            cmd = [
              "MarkdownPreviewToggle"
              "MarkdownPreview"
              "MarkdownPreviewStop"
            ];
            ft = "markdown";
          }
        ];
      };
    };
  };
}
