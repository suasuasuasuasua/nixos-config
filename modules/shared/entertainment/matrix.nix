{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # The electron client (prettiest)
    element-desktop
    # # The gnome client (more effient?)
    # fractal
    # # The vimmy client (more config in terminal)
    # iamb
    # # The vimmy client but more stable? (more config in terminal)
    # gomuks
  ];
}
