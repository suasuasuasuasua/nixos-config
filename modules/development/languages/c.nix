{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gcc
    gdb
    lldb
    gnumake
    cmake
    meson
  ];
}
