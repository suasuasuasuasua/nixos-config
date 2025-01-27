{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # The electron client (prettiest)
    element-desktop
  ];
}
