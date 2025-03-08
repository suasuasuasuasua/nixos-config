{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;

  cfg = config.home.gui.firefox;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.home.gui.firefox = {
    enable = lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # TODO: figure out profiles
      policies = { };
      profiles = {
        justinhoang = {
          name = "default";
          id = 0;
          search = {
            default = "Google";
          };
          # TODO: research settings
          settings = {
          };
          bookmarks = [
            {
              name = "wikipedia";
              tags = [ "wiki" ];
              keyword = "wiki";
              url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
            }
            {
              name = "kernel.org";
              url = "https://www.kernel.org";
            }
            {
              name = "Nix sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "homepage";
                  url = "https://nixos.org/";
                }
                {
                  name = "wiki";
                  tags = [
                    "wiki"
                    "nix"
                  ];
                  url = "https://wiki.nixos.org/";
                }
              ];
            }
          ];
          containers = {
            personal = {
              color = "red";
              icon = "fingerprint";
              id = 1;
            };
            coding = {
              color = "green";
              icon = "briefcase";
              id = 2;
            };
            shopping = {
              color = "blue";
              icon = "cart";
              id = 3;
            };
          };
          # TODO: add firefox extensions
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            betterttv
            ublock-origin
            vimium
          ];
        };
      };
    };
  };
}
