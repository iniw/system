{
  homeManagerModule =
    { lib, pkgs, ... }:
    {
      home.packages =
        let
          # mpv-lossless-cut needs ffmpeg in $PATH
          harunaWithFfmpeg = pkgs.symlinkJoin {
            name = "haruna";
            paths = [ pkgs.haruna ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = "wrapProgram $out/bin/haruna --prefix PATH : ${lib.makeBinPath [ pkgs.ffmpeg ]}";
          };
        in
        [ harunaWithFfmpeg ];

      xdg.configFile =
        let
          # Plays all audio tracks at the same time when a file has more than one.
          mix-audio-tracks = pkgs.writeText "mix-audio-tracks.lua" ''
            mp.add_hook("on_preloaded", 50, function()
                local inputs = {}
                for _, track in ipairs(mp.get_property_native("track-list")) do
                    if track.type == "audio" then
                        inputs[#inputs + 1] = "[aid" .. track.id .. "]"
                    end
                end

                -- With zero or one audio track there is nothing to mix. Clear the filter
                -- so that a value from the previous file does not break this one.
                if #inputs < 2 then
                    mp.set_property("lavfi-complex", "")
                    return
                end

                mp.set_property(
                    "lavfi-complex",
                    string.format("%s amix=inputs=%d:normalize=0 [ao]", table.concat(inputs, " "), #inputs)
                )
            end)
          '';

          # Cuts videos with ffmpeg, without re-encoding them.
          mpv-lossless-cut = pkgs.fetchFromGitHub {
            owner = "f0e";
            repo = "mpv-lossless-cut";
            rev = "v0.2.3";
            hash = "sha256-9kEel3BHIu6B91KvmeKrwbCNBRDlFn49/7MOgUJQONk=";
          };

          # Haruna does not load scripts from the mpv config directory, and it does not send key presses to mpv. Thus,
          # we load each script with a "startup" command, and give each script binding a Haruna shortcut.

          /*nixfmt:disable*/
          commands = [
            { type = "startup"; command = "load-script ${mix-audio-tracks}"; }
            { type = "startup"; command = "load-script ${mpv-lossless-cut}/mpv-lossless-cut.lua"; }
            # The keys are not the script's defaults (g, h, r, ...), because Haruna already uses some of those.
            { type = "shortcut"; command = "script-binding cut_set_start"; key = "I"; }
            { type = "shortcut"; command = "script-binding cut_set_end"; key = "O"; }
            { type = "shortcut"; command = "script-binding cut_set_start_sof"; key = "Shift+I"; }
            { type = "shortcut"; command = "script-binding cut_set_end_eof"; key = "Shift+O"; }
            { type = "shortcut"; command = "script-binding cut_render"; key = "E"; }
            { type = "shortcut"; command = "script-binding cut_toggle_mode"; key = "Shift+E"; }
            { type = "shortcut"; command = "script-binding cut_clear"; key = "Delete"; }
          ];
          /*nixfmt:enable*/

          groupName = index: "Command_${toString index}";
        in
        {
          "haruna/custom-commands.conf".text = lib.generators.toINIWithGlobalSection { } {
            globalSection.Counter = lib.length commands;
            sections =
              commands
              |> lib.imap0 (
                index: command:
                lib.nameValuePair (groupName index) {
                  Command = command.command;
                  Order = index;
                  OsdMessage = "";
                  Type = command.type;
                }
              )
              |> lib.listToAttrs;
          };

          "haruna/shortcuts.conf".text = lib.generators.toINI { } {
            Shortcuts =
              commands
              |> lib.imap0 (
                index: command: lib.optional (command ? key) (lib.nameValuePair (groupName index) command.key)
              )
              |> lib.concatLists
              |> lib.listToAttrs;
          };
        };
    };
}
