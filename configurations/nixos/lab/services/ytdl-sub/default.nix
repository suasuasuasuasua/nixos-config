let
  subscriptions = import ./subscriptions.nix;
in
{
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

  users.users.ytdl-sub.extraGroups = [ "samba" ];
}
