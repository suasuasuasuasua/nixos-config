{pkgs, ...}: {
  programs.nixvim = {
    plugins.obsidian = {
      enable = true;
      settings = {
        workspaces = [
          {
            name = "personal";
            path = "~/Documents/vaults/personal";
          }
          {
            name = "research";
            path = "~/Documents/vaults/research";
          }
        ];
        notes_subdir = "notes";

        # see below for full list of options 👇
        daily_notes = {
          # Optional, if you keep daily notes in a separate directory.
          folder = "dailies";
          # Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%Y-%m-%d";
          # Optional, if you want to change the date format of the default alias of daily notes.
          alias_format = "%B %-d, %Y";
          # TODO:figure out if we can add default tags
          # # Optional, default tags to add to each new daily note created.
          default_tags = [  "daily-notes"  ];
          # Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          template = null;
        };

        templates = {
          folder = "templates";
          date_format = "%Y-%m-%d-%a";
          time_format = "%H:%M";
        };

        # Disable all the mappings
        mappings = {};
      };
    };
  };
}
