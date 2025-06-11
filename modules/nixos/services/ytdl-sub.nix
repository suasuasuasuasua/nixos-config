{ config, lib, ... }:
let
  serviceName = "ytdl-sub";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Lightweight tool to automate downloading and metadata generation with yt-dlp
    '';
  };

  config = lib.mkIf cfg.enable {
    services.ytdl-sub = {
      instances = {
        music = {
          enable = true;
          # WARNING: don't mess with the working directory
          config = { };
          # TODO: modularize this
          subscriptions = {
            "__preset__" = {
              overrides = {
                # WARNING: for some reason can't use a root path like
                # /zshare/media/
                # Will need to investigate...but this is a nice automation. Cut
                # and paste to the samba share is fine for now probably
                music_directory = "music";
                music_video_directory = "music_videos";
              };
            };
            "YouTube Releases" = {
              # Sets genre tag to "Jazz"
              "= Jazz" = {
                "Thelonious Monk" = "https://www.youtube.com/@officialtheloniousmonk/releases";
              };
              "= K-Pop" = {
                "aespa" = "https://www.youtube.com/@aespa/releases";
                "BABYMONSTER" = "https://www.youtube.com/@BABYMONSTER/releases";
                "ITZY" = "https://www.youtube.com/@ITZY/releases";
                "IVE" = "https://www.youtube.com/@IVEstarship/releases";
                "JENNIE" = "https://www.youtube.com/@jennierubyjane/releases";
                "KISS OF LIFE" = "https://www.youtube.com/@KISSOFLIFE_official/releases";
                "LE SSERAFIM" = "https://www.youtube.com/@LESSERAFIM_official/releases";
                "NewJeans" = "https://www.youtube.com/@NewJeans_official/releases";
                "ROSÉ" = "https://www.youtube.com/@roses_are_rosie/releases";
                "XG" = "https://www.youtube.com/@xg_official/releases";
              };
            };
          };
        };
      };
    };
  };
}
