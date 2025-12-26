# self hosted minecraft server
#
# https://wiki.nixos.org/wiki/Minecraft_Server
# https://github.com/Infinidoge/nix-minecraft
{ inputs, pkgs, ... }:
let
  # default port = 25565
  port = 25565;
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  # Minecraft server (multi) settings
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers = {
      "theboys" = {
        enable = true;
        whitelist = {
          "ButOnYourNooty" = "33574a43-42c6-4813-8fa1-a2e1c44e32c3";
          "INSPECTORPOOPY" = "e55f7b34-6a98-4e9a-a770-1ebd0cf123b1";
          "suasuasua9582" = "a0e73908-7ac7-42f8-8e2d-6b6e4cdf3353";
        };
        # https://minecraft.wiki/w/Server.properties#Keys
        serverProperties = {
          server-port = port;
          difficulty = 2; # normal difficulty
          gamemode = 0; # survival
          max-players = 5;
          motd = "the boys dec-2025";
          white-list = true;
          allow-cheats = false;
        };
        jvmOpts = "-Xms2048M -Xmx4096M";

        # Specify the custom minecraft server package
        package = pkgs.vanillaServers.vanilla-1_21_11;
      };
      "testing" = {
        enable = true;
        whitelist = {
          "suasuasua9582" = "a0e73908-7ac7-42f8-8e2d-6b6e4cdf3353";
        };
        # https://minecraft.wiki/w/Server.properties#Keys
        serverProperties = {
          server-port = port + 1;
          difficulty = 2; # normal difficulty
          gamemode = 0; # survival
          max-players = 1;
          motd = "my testing server";
          white-list = true;
          allow-cheats = false;
        };
        jvmOpts = "-Xms1024M -Xmx2048M";

        # Specify the custom minecraft server package
        package = pkgs.vanillaServers.vanilla-1_21_11;
      };
    };
  };

  # NOTE: original guide with single server
  # services.minecraft-server = {
  #   enable = true;
  #   eula = true;
  #   package = pkgs.minecraft-server;
  #   openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
  #   declarative = true;
  #   # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
  #   whitelist = {
  #     "BOBSHMURDA911" = "1cf27c2c-54c6-488d-937d-5e0daee50227";
  #     "INSPECTORPOOPY" = "e55f7b34-6a98-4e9a-a770-1ebd0cf123b1";
  #     "suasuasua9582" = "a0e73908-7ac7-42f8-8e2d-6b6e4cdf3353";
  #   };
  #   # https://minecraft.wiki/w/Server.properties#Keys
  #   serverProperties = {
  #     server-port = port;
  #     difficulty = 2; # normal difficulty
  #     gamemode = 0; # survival
  #     max-players = 5;
  #     motd = "the boys";
  #     white-list = true;
  #     allow-cheats = false;
  #   };
  #   jvmOpts = "-Xms2048M -Xmx4096M";
  # };
}
