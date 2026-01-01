{ inputs, ... }:
{
  home-manager.users = {
    "admin" = {
      imports = [ "${inputs.self}/modules/home/cli" ];

      custom.home = {
        cli = {
          fzf.enable = true;
          git.enable = true;
          tmux.enable = true;
          zsh.enable = true;
        };
      };
    };
  };
}
