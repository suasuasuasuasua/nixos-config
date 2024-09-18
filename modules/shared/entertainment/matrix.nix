{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # TODO: figure out which matrix client that I like the best
    #
    # The electron client (prettiest)
    element-desktop
    # # The gnome client (more effient?)
    # fractal
    # # The vimmy client (more config in terminal)
    # iamb
  ];
}
