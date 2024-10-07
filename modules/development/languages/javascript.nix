{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      nodejs
      typescript
    ]
    ++ (with pkgs.nodePackages; [
      prettier
    ]);
}
