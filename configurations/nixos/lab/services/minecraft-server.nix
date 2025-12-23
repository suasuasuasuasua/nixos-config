# self hosted minecraft server
#
# https://wiki.nixos.org/wiki/Minecraft_Server
{ pkgs, ... }:
let
  # default port = 25565
  port = 25565;
in
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    package = pkgs.minecraft-server;
    openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
    declarative = true;
    # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
    whitelist = {
      "BOBSHMURDA911" = "1cf27c2c-54c6-488d-937d-5e0daee50227";
      "INSPECTORPOOPY" = "e55f7b34-6a98-4e9a-a770-1ebd0cf123b1";
      "suasuasua9582" = "a0e73908-7ac7-42f8-8e2d-6b6e4cdf3353";
    };
    # https://minecraft.wiki/w/Server.properties#Keys
    serverProperties = {
      server-port = port;
      difficulty = 2; # normal difficulty
      gamemode = 0; # survival
      max-players = 5;
      motd = "the boys";
      white-list = true;
      allow-cheats = false;
    };
    jvmOpts = "-Xms2048M -Xmx4096M";
  };
}
