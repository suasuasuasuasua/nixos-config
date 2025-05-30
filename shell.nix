{
  self,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
pkgs.mkShellNoCC {
  # enable the shell hooks
  shellHook =
    # bash
    ''
      git remote update && git status -uno
    ''
    # install the git hooks
    + self.checks.${system}.git-hooks-check.shellHook;

  # define the programs available when running `nix develop`
  # add the packages from the git-hooks list too
  buildInputs = self.checks.${system}.git-hooks-check.enabledPackages;
  packages = with pkgs; [
    # cli
    btop # system monitoring
    fastfetch # system information

    # commands
    bat # better cat
    just # command runner
    tokei # lines of code
    vim-startuptime # proflie vim and neovim

    # lsp
    nil # lsp 1
    nixd # lsp 2
    nixfmt-rfc-style # nix formatter
    marksman # markdown
    markdownlint-cli # markdown linter

    # nix support
    caligula # burn the iso images
    home-manager
    nix
    (
      # nix helper
      #
      # TODO: remove when nh=4.1.0 hits stable
      # https://github.com/nix-community/nh/issues/293
      if pkgs.stdenv.isDarwin then
        nh.overrideAttrs rec {
          pname = "nh";
          version = "4.1.0";

          src = fetchFromGitHub {
            owner = "nix-community";
            repo = "nh";
            rev = "v${version}";
            hash = "sha256-OiuhBrJe1AyVxC+AV4HMJ+vhDvUfCyLpBmj+Fy7MDtM=";
          };
          cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
            inherit src;
            hash = "sha256-/tbmzGUd1b4oa+29+eFdkE4l8vxMoIdHx40YgErY9pY=";
          };
        }
      else
        nh
    )
    nix-output-monitor # nix output monitor
    nvd # nix/nixos package version diff tool

    # source control
    commitizen # templated commits and bumping
    git # source control program
  ];
}
