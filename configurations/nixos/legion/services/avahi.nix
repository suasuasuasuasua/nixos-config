# avahi is used to expose your hostname on the network
#
# for example, if your computer is called "pi", it will be accessible using
# pi.local for other computers on the same LAN
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };
}
