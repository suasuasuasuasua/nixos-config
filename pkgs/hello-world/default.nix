{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "hello-world";
  text = ''
    echo "Hello, world!"
  '';
}
