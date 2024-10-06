{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    markdownlint-cli
  ];
}
