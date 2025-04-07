{ flake, pkgs, ... }:
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

      # import the modules
      (self + /modules/home/cli)
      (self + /modules/home/desktop)
      (self + /modules/home/development)
      (self + /modules/home/gui)
    ];

    # TODO: if this gets too complex/long, modularize into folders
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

      desktop.sway = {
        enable = true;
        modifier = "Mod4"; # super key
        input = {
          # built-in touchpad
          "type:touchpad" = {
            natural_scroll = "enabled";
            dwt = "disabled"; # enable typing while using touchpad
            tap = "enabled"; # tap to click
            middle_emulation = "enabled"; # middle finger triple click
            scroll_factor = "0.15"; # scroll speed
          };

          # logitech mouse
          "1133:16468:Logitech_Wireless_Mouse" = {
            pointer_accel = "0.25"; # mouse speed
          };
        };
        output = {
          "*" = {
            bg = "${pkgs.sway}/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill";
          };
          # TODO: workspace 1 is the built-in monitor even though it's closed??

          # BOE 0x095F Unknown
          # built-in monitor
          eDP-1 = {
            scale = "2.0";
            mode = "2256x1504@60hz";
          };

          # AOC Q27G3XMN 1APQAJA005364
          # gaming monitor
          HDMI-A-1 = {
            scale = "2.0";
            mode = "2560x1440@144Hz";
          };
        };
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
            arrow.enable = true; # bookmarks (;)
            auto-save.enable = true; # autosave the file
            auto-session.enable = false; # auto generate and load a session file
            barbar.enable = false; # better tabs
            clipboard-image.enable = true; # paste images from clipboard
            diffview.enable = true; # show git-rev diffs
            dropbar.enable = true; # breadcrumb navigation
            lazygit.enable = true; # lazygit integration
            lualine.enable = true; # status line 3
            markdown-preview.enable = true; # local live markdown preview server
            neogit.enable = true; # git integration (secondary to lazygit)
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
}
