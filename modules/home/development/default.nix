# By default, only do neovim!
{
  imports = [
    ./neovim
    ./packages.nix
    ./shell.nix
  ]; # TODO: how to import vscode based on macOS or not? don't think is possible
}
