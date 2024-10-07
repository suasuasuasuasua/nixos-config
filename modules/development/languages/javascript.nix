{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      nodejs
      typescript-language-server
    ]
    ++ (with pkgs.nodePackages; [
      prettier
    ]);
}
