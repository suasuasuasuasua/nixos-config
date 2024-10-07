{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      nodejs
    ]
    ++ (with pkgs.nodePackages; [
      prettier
    ]);
}
