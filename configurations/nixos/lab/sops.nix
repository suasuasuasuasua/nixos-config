{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # This will add secrets.yml to the nix store
  sops = {
    defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";

    age = {
      # This will automatically import SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      # This is using an age key that is expected to already be in the filesystem
      keyFile = "${config.users.users.justinhoang.home}/.config/sops/age/keys.txt";

      # This will generate a new key if the key specified above does not exist
      generateKey = true;
    };
  };

  # first time launch
  system.activationScripts.fixSopsKeyOwnership = lib.mkAfter ''
    keyFile="${config.users.users.justinhoang.home}/.config/sops/age/keys.txt"
    if [ -f "$keyFile" ]; then
      chown justinhoang:users "$keyFile"
      chmod 600 "$keyFile"
    fi
  '';
}
