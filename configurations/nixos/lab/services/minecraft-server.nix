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
      "kj" = {
        enable = true;
        whitelist = {
          "suasuasua9582" = "a0e73908-7ac7-42f8-8e2d-6b6e4cdf3353";
          "katierae1114" = "2bd24d98-79a8-4ec5-9f9a-992fde6b806f";
        };
        # https://minecraft.wiki/w/Server.properties#Keys
        serverProperties = {
          server-port = port + 1;
          difficulty = 2; # normal difficulty
          gamemode = 0; # survival
          max-players = 2;
          motd = "katelyn and justin";
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
          # Minecraft server properties
          # https://minecraft.fandom.com/wiki/Server.properties#Java_Edition
          # (File modification date and time)
          allow-cheats = true;
          enable-jmx-monitoring = false;
          "rcon.port" = 25575;
          level-seed = "";
          gamemode = "creative";
          enable-command-block = false;
          enable-query = false;
          generator-settings = "";
          enforce-secure-profile = true;
          level-name = "world";
          motd = "my testing server";
          "query.port" = port + 1;
          pvp = true;
          generate-structures = true;
          max-chained-neighbor-updates = 1000000;
          difficulty = "peaceful";
          network-compression-threshold = 256;
          max-tick-time = 60000;
          require-resource-pack = false;
          use-native-transport = true;
          max-players = 1;
          online-mode = true;
          enable-status = true;
          allow-flight = false;
          initial-disabled-packs = "";
          broadcast-rcon-to-ops = true;
          view-distance = 10;
          server-ip = "";
          resource-pack-prompt = "";
          allow-nether = true;
          server-port = port + 2;
          enable-rcon = false;
          sync-chunk-writes = true;
          op-permission-level = 4;
          prevent-proxy-connections = false;
          hide-online-players = false;
          resource-pack = "";
          entity-broadcast-range-percentage = 100;
          simulation-distance = 10;
          "rcon.password" = "";
          player-idle-timeout = 0;
          force-gamemode = false;
          rate-limit = 0;
          hardcore = false;
          white-list = true;
          broadcast-console-to-ops = true;
          spawn-npcs = true;
          spawn-animals = true;
          log-ips = true;
          function-permission-level = 2;
          initial-enabled-packs = "vanilla";
          level-type = "minecraft\:normal";
          text-filtering-config = "";
          spawn-monsters = true;
          enforce-whitelist = false;
          spawn-protection = 16;
          resource-pack-sha1 = "";
          max-world-size = 29999984;
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
