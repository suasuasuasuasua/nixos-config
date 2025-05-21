{
  inputs,
  ...
}:
{
  imports = [
    # import the modules
    "${inputs.self}/modules/home"

    "${inputs.self}/modules/home/cli"
    "${inputs.self}/modules/home/development"
  ];

  home = {
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
        enable = true;
        # enable LSPs for _server-like_ things
        lsp = { };
        plugins = { };
      };
      zsh.enable = true;
    };
  };
}
