{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  # TODO: figure out a dynamic way to allocate this (not that there any other
  # users...just helps my brain avoid hardcode)

  # Enable home-manager for "justinhoang" user
  home-manager.users."justinhoang" = {
    imports = [
      (self + /configurations/home/justinhoang.nix)
      self.homeModules.default
    ];

    # TODO: if this gets too complex/long, modularize into folders
    config.home = {
      cli = {
        bat.enable = true;
        devenv.enable = true;
        direnv.enable = true;
        fzf.enable = true;
        git.enable = true;
        github.enable = true;
        gnupg.enable = true;
        tmux.enable = true;
      };

      development = {
        neovim = {
          enable = true;
          # enable LSPs for _server-like_ things
          lsp = {
            bashls.enable = true;
            docker_compose_language_service.enable = true;
            dockerls.enable = true;
            jsonls.enable = true;
            nginx_language_server.enable = true;
            nil_ls.enable = true;
            nixd.enable = true;
            ruff.enable = true;
            sqls.enable = true;
            tinymist.enable = true;
            yamlls.enable = true;
          };
          plugins = {
            airline.enable = true;
            auto-save.enable = true;
            diffview.enable = true;
            lazygit.enable = true;
            markdown-preview.enable = true;
            repeat.enable = true;
            surround.enable = true;
            tmux.enable = true;
            treesitter.enable = true;
            ufo.enable = true;
          };
        };
        packages.enable = true;
        shell.enable = true;
      };
    };
  };
}
