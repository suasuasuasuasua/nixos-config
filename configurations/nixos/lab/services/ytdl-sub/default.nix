let
  subscriptions = import ./subscriptions.nix;
in
{
  users.users.ytdl-sub.extraGroups = [ "samba" ];

  services.ytdl-sub = {
    instances = {
      music = {
        inherit subscriptions;

        enable = true;
        # WARNING: don't mess with the working directory!
        config = { };
      };
    };
  };
}
