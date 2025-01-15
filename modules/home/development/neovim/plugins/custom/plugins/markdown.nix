{
  programs.nixvim = {
    # # TODO: wtf why isn't this working
    # # Better renderer
    # plugins.render-markdown = {
    #   enable = true;
    # };

    # Obsdian Integration
    plugins.obsidian = {
      enable = true;
      settings = {
        workspaces = [
          {
            name = "general";
            path = "~/Documents/vaults/personal";
          }
        ];
        notes_subdir = "01-fleeting";

        # see below for full list of options 👇
        daily_notes = {
          # Optional, if you keep daily notes in a separate directory.
          folder = "00-dailies";
          # Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%Y-%m-%d";
          # Optional, if you want to change the date format of the default alias of daily notes.
          alias_format = "%B %-d, %Y";
          # Optional, default tags to add to each new daily note created.
          default_tags = [ "daily-notes" ];
          # Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          template = null;
        };

        templates = {
          folder = "templates";
          date_format = "%Y-%m-%d-%a";
          time_format = "%H:%M";
        };

        # Disable all the mappings
        mappings = { };

        # Where to put new notes. Valid options are
        # * "current_dir" - put new notes in same directory as the current
        # buffer.
        # * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "notes_subdir";

        note_id_func =
          /*
          lua
          */
          ''
            function(title)
              local suffix = ""
              if title ~= nil then
                -- If title is given, transform it into valid file name.
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
              else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                  suffix = suffix .. string.char(math.random(65, 90))
                end
              end

              return tostring(os.date "%Y-%m-%dT%H-%M-%S") .. "_" .. suffix
             end
          '';

        # Disable the UI rendering for obsidian
        ui.enable = false;
      };
    };

    # Preview
    plugins.markdown-preview = {
      enable = true;
    };
  };
}
