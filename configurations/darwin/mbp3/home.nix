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
        bat.enable = true; # better cat
        comma.enable = true; # try out programs with `,`
        devenv.enable = true; # easy dev environemnts
        direnv.enable = true; # switch dev environments with .envrc files
        fzf.enable = true; # fuzzy finder
        git.enable = true; # source control
        github.enable = true; # github cli integration
        gnupg.enable = true; # gpg key signing
        tmux.enable = true; # terminal multiplexer
      };

      development = {
        neovim = {
          enable = true; # enable nixvim config
          # enable LSPs for _server-like_ things
          lsp = {
            bashls.enable = true; # bash
            clangd.enable = true; # c/c++
            cssls.enable = true; # css
            docker_compose_language_service.enable = true; # docker compose
            dockerls.enable = true; # dockerfile
            gopls.enable = true; # go
            html.enable = true; # html
            jsonls.enable = true; # json
            nginx_language_server.enable = true; # nginx
            ltex.enable = true; # latex
            marksman.enable = true; # markdown
            nil_ls.enable = true; # nix
            # nixd.enable = true; # nix
            pyright.enable = true; # python
            ruff.enable = true; # python
            rust_analyzer.enable = true; # rust
            sqls.enable = true; # sql
            tailwindcss.enable = true; # tailwindcss
            taplo.enable = true; # toml
            texlab.enable = true; # latex
            tinymist.enable = true; # typst
            yamlls.enable = true; # yaml
          };
          plugins = {
            airline.enable = true; # status line
            arrow.enable = true; # bookmarks (;)
            auto-save.enable = true; # autosave the file
            auto-session.enable = false; # auto generate and load a session file
            barbar.enable = false; # better tabs
            clipboard-image.enable = true; # paste images from clipboard
            diffview.enable = true; # show git-rev diffs
            dropbar.enable = true; # breadcrumb navigation
            lazygit.enable = true; # lazygit integration
            markdown-preview.enable = true; # local live markdown preview server
            neogit.enable = true; # git integration (secondary to lazygit)
            ollama = {
              # ollama llm integration
              enable = true;
              model = "gemma3";
              url = "http://127.0.0.1:11434"; # local ollama instance
            };
            render-markdown.enable = true; # render markdown in the terminal
            repeat.enable = true; # repeat edits (.)
            surround.enable = true; # surround operations
            tmux.enable = true; # tmux navigation integration
            treesitter.enable = true; # treesitter extensions integration
            typst.enable = true; # typst preview and syntax
            ufo.enable = true; # better folding support
            vimtex.enable = true; # latex support
            zen-mode.enable = true; # zen mode support
          };
        };
        zsh.enable = true; # preferred shell
      };

      gui = {
        firefox.enable = true; # browser
        spotify.enable = true; # music platform
        vscode.enable = true; # text editor
      };
    };
  };
}
