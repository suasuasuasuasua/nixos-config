{ inputs, ... }:
{
  # Enable home-manager for "justinhoang" user
  home-manager.users = {
    "justinhoang" = {
      imports = [
        # import the modules
        "${inputs.self}/modules/home/cli"
        "${inputs.self}/modules/home/development"
        "${inputs.self}/modules/home/gui"
      ];

      config.home = {
        cli = {
          bat.enable = true;
          comma.enable = true;
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
              bashls.enable = true; # bash
              clangd.enable = true; # c/c++
              cssls.enable = true; # css
              docker_compose_language_service.enable = true; # docker compose
              dockerls.enable = true; # dockerfile
              gopls.enable = true; # go
              html.enable = true; # html
              jsonls.enable = true; # json
              nginx_language_server.enable = true; # nginx
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
              arrow.enable = true; # bookmarks (;)
              auto-dark-mode.enable = true; # switch theme based on os
              auto-save.enable = true; # autosave the file
              bufferline.enable = true; # prettier bufferline top bar
              diffview.enable = true; # show git-rev diffs
              dropbar.enable = true; # breadcrumb navigation
              flash.enable = true; # navigate faster with s,f,t
              grug-far.enable = true; # find and rename across files
              hex.enable = true; # hex editor
              img-clip.enable = true; # paste images from clipboard
              lazygit.enable = true; # lazygit integration
              leetcode.enable = true; # leetcode sadge
              lualine.enable = true; # status line
              markdown-preview.enable = true; # local live markdown preview server
              neogit.enable = true; # git integration (secondary to lazygit)
              ollama = {
                enable = true; # ollama llm integration
                model = "gemma3";
                url = "http://127.0.0.1:11434"; # local ollama instance
              };
              render-markdown.enable = true; # render markdown in the terminal
              repeat.enable = true; # repeat edits (.)
              scope.enable = true; # scope the buffers (open files) to tabs
              surround.enable = true; # surround operations
              tmux.enable = true; # tmux navigation integration
              treesitter.enable = true; # treesitter extensions integration
              trouble.enable = true; # better fix diagnostics
              twilight.enable = true; # focused writing
              typst.enable = true; # typst preview and syntax
              ufo.enable = true; # better folding support
              undotree.enable = true; # undo tree visualizer
              vimtex.enable = true; # latex support
              zen-mode.enable = true; # zen mode support
            };
          };
          zsh.enable = true;
        };

        gui = {
          alacritty.enable = true;
          firefox.enable = true;
          obs.enable = true;
          spotify.enable = true;
          vscode.enable = true;
        };
      };
    };
  };
}
