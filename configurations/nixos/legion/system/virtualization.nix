{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;

    # https://wiki.nixos.org/wiki/Docker#Rootless_Docker
    rootless = {
      enable = true;
      setSocketVariable = true;
      # Optionally customize rootless Docker daemon settings
      daemon.settings = {
        dns = [
          "192.168.0.250" # local dns
          "1.1.1.1" # cloudflare
          "8.8.8.8" # google
        ];
        registry-mirrors = [ "https://mirror.gcr.io" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [ lazydocker ];

  # https://wiki.nixos.org/wiki/Category:Virtualization
  # Installing a hypervisor on the host system.
  virtualisation.libvirtd.enable = true;
  # if you use libvirtd on a desktop environment
  programs.virt-manager.enable = true; # can be used to manage non-local hosts as well
  # Installing the appropriate guest utilities on a virtualised system.
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
