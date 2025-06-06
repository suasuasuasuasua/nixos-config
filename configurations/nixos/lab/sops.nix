{ inputs, config, ... }:
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

    # This is the actual specification of the secrets.
    secrets."duckdns/token" = { };
    secrets."acme/namecheap_api" = { };
  };
}
