{ inputs, pkgs, ... }:
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        # import the modules
        "${inputs.self}/modules/home/cli"
      ];

      custom.home = {
        cli = {
          bat.enable = true;
          btop.enable = true; # system monitor
          comma.enable = true;
          devenv.enable = true;
          direnv.enable = true;
          fzf.enable = true;
          git.enable = true;
          github.enable = true;
          gnupg.enable = true;
          starship.enable = true;
          tmux.enable = true;
          zsh.enable = true;
        };
      };
      home.packages =
        let
          nixvim = import ./nixvim.nix {
            inherit inputs pkgs;
          };
        in
        [ nixvim ];
    };
  };
}
