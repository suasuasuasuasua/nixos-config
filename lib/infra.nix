# Shared network topology for the homelab infrastructure.
# Passed to all NixOS hosts via specialArgs as `infra`.
# Public keys are not secrets — WireGuard public keys are safe to commit.
{
  vps0 = {
    publicIp = "5.78.184.15";
    wgIp = "10.101.0.1";
    wgPort = 51820;
    wgPublicKey = "k2a0D0OUEsZQV6geIKOscTNVbiUVZquqh49zT6A1MRo=";
  };
  vps1 = {
    wgIp = "10.101.0.3";
    wgPublicKey = "X/sp+cUKT7sx9sNnFUXDLylXuIEBx8iTLyG4QBllfS0=";
  };
  lab = {
    wgIp = "10.101.0.2";
    wgPublicKey = "JVBP0NWpR70JT0bUoFsunFkGT9YZSY8O/UeMdUxAXlU=";
  };
}
