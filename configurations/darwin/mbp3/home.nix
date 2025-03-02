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
      inputs.mac-app-util.homeManagerModules.default

      (self + /configurations/home/justinhoang.nix)
      self.homeModules.default

      # import modules
      (self + /modules/home/cli)
      (self + /modules/home/development)
      (self + /modules/home/gui)
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
            clangd.enable = true;
            cssls.enable = true;
            docker_compose_language_service.enable = true;
            dockerls.enable = true;
            gopls.enable = true;
            html.enable = true;
            jsonls.enable = true;
            nginx_language_server.enable = true;
            ltex.enable = true;
            nil_ls.enable = true;
            # nixd.enable = true;
            ruff.enable = true;
            rust_analyzer.enable = true;
            sqls.enable = true;
            tailwindcss.enable = true;
            taplo.enable = true;
            texlab.enable = true;
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
        comma.enable = true;
        shell.enable = true;
        vscode.enable = true; # text editor
      };

      gui = {
        spotify.enable = true; # music platform
      };
    };
  };
}
